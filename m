Return-Path: <linux-kernel-owner+w=401wt.eu-S1753725AbXFPHrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbXFPHrg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 03:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXFPHr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 03:47:29 -0400
Received: from il.qumranet.com ([82.166.9.18]:38074 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbXFPHr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 03:47:29 -0400
Message-ID: <4673958E.7090707@qumranet.com>
Date: Sat, 16 Jun 2007 10:47:26 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: David Brown <dmlb2000@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [GIT PULL] KVM fix for 2.6.22
References: <11819006133865-git-send-email-avi@qumranet.com> <9c21eeae0706150736o6c581222oca883161e8062ed2@mail.gmail.com>
In-Reply-To: <9c21eeae0706150736o6c581222oca883161e8062ed2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Sat, 16 Jun 2007 10:47:26 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brown wrote:
>
> Yes thank you for the fix Avi. btw what version of kvm is in 2.6.22?
> the kvm wiki doesn't say.
>

It's somewhere between kvm-21 and kvm-22.  Any recent version of the
userspace can be used to drive it (i.e. starting with 2.6.22, there is
no need to match kernel and userspace versions).

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

