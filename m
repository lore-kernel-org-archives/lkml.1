Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbZASTWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbZASTWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 14:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbZASTWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 14:22:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48307 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbZASTWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 14:22:34 -0500
Message-ID: <4974D29A.2070607@zytor.com>
Date: Mon, 19 Jan 2009 11:20:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, Ian Kent <raven@themaw.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] autofs: fix the wrong usage of the deprecated	task_pgrp_nr()
References: <20090119070801.GA21686@redhat.com> <1232352677.3136.103.camel@zeus.themaw.net> <20090119083208.GA25297@redhat.com> <1232363717.3136.134.camel@zeus.themaw.net> <20090119124253.GA3268@redhat.com> <1232372016.3136.155.camel@zeus.themaw.net> <20090119143046.GA8284@redhat.com> <20090119174836.GA11295@us.ibm.com> <20090119180534.GA22913@redhat.com> <20090119182447.GA15140@us.ibm.com> <20090119191729.GB24852@redhat.com>
In-Reply-To: <20090119191729.GB24852@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> 
> Actually, I am very much surprized this one-liner patch has so
> many questions. Isn't it "obiously correct" ?
> 

Obviously not.

	-hpa

