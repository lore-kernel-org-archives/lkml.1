Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbXJALa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbXJALa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 07:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbXJALaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 07:30:21 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49798 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbXJALaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 07:30:20 -0400
Message-ID: <4700DA44.8020706@garzik.org>
Date: Mon, 01 Oct 2007 07:30:12 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: patches@x86-64.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] [50/50] x86_64: Remove fpu io port resource
References: <200709221231.836138000@suse.de> <20070921223251.1312913DCD@wotan.suse.de> <46F44D27.4050704@garzik.org> <200710011240.35802.ak@suse.de>
In-Reply-To: <200710011240.35802.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> So far I still maintain i386 and x86-64. If Thomas wants to take both
> over completely he can do that; but I won't bother handling any patches i didn't 
> write then anymore.


What does that mean?

Didn't we all agree that x86 and x86-64 are going to be merged?

If yes, isn't it logical to avoid patches that extend the separation?

This is just basic playing-well-with-others fundamentals.

	Jeff


