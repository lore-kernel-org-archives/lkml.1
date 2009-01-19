Return-Path: <linux-kernel-owner+w=401wt.eu-S1757822AbZASTfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbZASTfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 14:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbZASTfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 14:35:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42523 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbZASTfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 14:35:01 -0500
Date: Mon, 19 Jan 2009 20:32:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Ian Kent <raven@themaw.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] autofs: fix the wrong usage of the deprecated
	task_pgrp_nr()
Message-ID: <20090119193244.GA26784@redhat.com>
References: <20090119083208.GA25297@redhat.com> <1232363717.3136.134.camel@zeus.themaw.net> <20090119124253.GA3268@redhat.com> <1232372016.3136.155.camel@zeus.themaw.net> <20090119143046.GA8284@redhat.com> <20090119174836.GA11295@us.ibm.com> <20090119180534.GA22913@redhat.com> <20090119182447.GA15140@us.ibm.com> <20090119191729.GB24852@redhat.com> <4974D29A.2070607@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4974D29A.2070607@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19, H. Peter Anvin wrote:
>
> Oleg Nesterov wrote:
>>
>> Actually, I am very much surprized this one-liner patch has so
>> many questions. Isn't it "obiously correct" ?
>>
>
> Obviously not.

Do you agree the current code is not right?

What do you not like in this change?

Oleg.

