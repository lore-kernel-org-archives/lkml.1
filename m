Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbXD1XqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbXD1XqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 19:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbXD1XqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 19:46:19 -0400
Received: from gw.goop.org ([64.81.55.164]:43439 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427AbXD1XqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 19:46:18 -0400
Message-ID: <4633DCCF.2060809@goop.org>
Date: Sat, 28 Apr 2007 16:46:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: introduce voyager smp_ops, fix voyager build
References: <463382E5.9060701@goop.org>	<m14pn0dv2j.fsf@ebiederm.dsl.xmission.com> <4633D5E9.8030403@goop.org>
In-Reply-To: <4633D5E9.8030403@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Eric W. Biederman wrote:
>   
>> Unless I have missed something early_gdt_descr still needs to be updated. 
>>   
>>     
>
> The patch is on top of Andi's current queue, which includes quite a few
> boot-time gdt setup cleanups.  early_gdt_descr has gone.

Hm, I was thinking of something else.  Checking...

    J
