Return-Path: <linux-kernel-owner+w=401wt.eu-S1423742AbXEAEIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423742AbXEAEIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946311AbXEAEHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:07:47 -0400
Received: from terminus.zytor.com ([192.83.249.54]:49615 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946601AbXEAEA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 00:00:59 -0400
Message-ID: <4636BB6B.9070300@zytor.com>
Date: Mon, 30 Apr 2007 21:00:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <20070428758.455116000@suse.de>	 <20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>	 <m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>	 <m14pmz8bbb.fsf@ebiederm.dsl.xmission.com>	 <1177902195.30071.203.camel@localhost.localdomain>	 <463572B7.90202@zytor.com>	 <1177909434.30071.216.camel@localhost.localdomain>	 <m1ejm16flv.fsf@ebiederm.dsl.xmission.com> <1177990722.28659.39.camel@localhost.localdomain> <4636B7DE.5050005@zytor.com>
In-Reply-To: <4636B7DE.5050005@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Rusty Russell wrote:
>> It'd be nicer if there were a "struct boot_params" declaration, but we
>> can't have everything.
> 
> It's in my patchset-under-development.
> 
> (Preview snapshot:
> http://userweb.kernel.org/~hpa/setup-snapshot-2007.04.30.patch)

Just pushed out a git tree:

http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-newsetup.git;a=summary

	-hpa
