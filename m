Return-Path: <linux-kernel-owner+w=401wt.eu-S1751648AbXD1XQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbXD1XQw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 19:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbXD1XQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 19:16:51 -0400
Received: from gw.goop.org ([64.81.55.164]:57185 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbXD1XQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 19:16:50 -0400
Message-ID: <4633D5E9.8030403@goop.org>
Date: Sat, 28 Apr 2007 16:16:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andi Kleen <ak@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] i386: introduce voyager smp_ops, fix voyager build
References: <463382E5.9060701@goop.org> <m14pn0dv2j.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m14pn0dv2j.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Unless I have missed something early_gdt_descr still needs to be updated. 
>   

The patch is on top of Andi's current queue, which includes quite a few
boot-time gdt setup cleanups.  early_gdt_descr has gone.

    J
