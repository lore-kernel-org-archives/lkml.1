Return-Path: <linux-kernel-owner+w=401wt.eu-S965774AbXDJWTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965774AbXDJWTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965838AbXDJWTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:19:36 -0400
Received: from gw.goop.org ([64.81.55.164]:46213 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965774AbXDJWTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:19:35 -0400
Message-ID: <461C0D70.50005@goop.org>
Date: Tue, 10 Apr 2007 15:19:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/2] Account for module percpu space separately from kernel
 percpu
References: <461BC4B6.9060006@goop.org> <m1abxfyiwk.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1abxfyiwk.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> I think I have already done this but in case I haven't.
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> I see any problems there.
>   
^don't?
