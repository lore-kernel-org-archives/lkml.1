Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbXC0WLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbXC0WLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 18:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbXC0WLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 18:11:40 -0400
Received: from gw.goop.org ([64.81.55.164]:36535 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbXC0WLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 18:11:39 -0400
Message-ID: <46099696.3020003@goop.org>
Date: Tue, 27 Mar 2007 15:11:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Zachary Amsden <zach@vmware.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Xen-devel] [PATCH] Add smp_ops interface
References: <46099624.30606@goop.org>
In-Reply-To: <46099624.30606@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> [ Andrew: Patch is based on 2.6.21-rc5-mm1 + the pda->percpu patch I
>   posted the other day.  It will have a minor context conflict without
>   that patch, but is otherwise standalone. ]
>   
Sorry, it also depends on simplify-smp_call_function.patch, which I'll
repost shortly.

    J
