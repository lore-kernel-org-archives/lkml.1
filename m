Return-Path: <linux-kernel-owner+w=401wt.eu-S932282AbXHCNGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbXHCNGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 09:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763068AbXHCNEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 09:04:04 -0400
Received: from main.gmane.org ([80.91.229.2]:48804 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762894AbXHCNEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 09:04:01 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleksandr Natalenko <pfactum@gmail.com>
Subject: Re: Scheduler Situation
Date: Fri, 3 Aug 2007 12:52:15 +0000 (UTC)
Message-ID: <loom.20070803T144718-943@post.gmane.org>
References: <cdc89fe60708030507r29283942mbb9947edbe04e23a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 62.68.95.23 (Opera/9.22 (X11; Linux i686; U; ru))
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

T. J. Brumfield <enderandrew <at> gmail.com> writes:

> 1 - Can someone please explain why the kernel can be modular in every
> other aspect, including offering a choice of IO schedulers, but not
> kernel schedulers?

IMHO, Linus has a grudge against Con, but I can't understand, why. Con has 
written nice code, I use it even now, I'm glad to have nice high-interactive 
system on desktop. But "a grudge" is not an argument for Linus, it's better not 
to make a decision by himself, but to let the community to decide, what is 
better - CFS or SD.

Question is not only in CFS vs SD, but in -ck patchset. Linus must remember 
that he has lost nice code and nice maintainer, and it's not a right decision. 
Linux is a public OS, so let people decide themselves, but not Linus himself.

