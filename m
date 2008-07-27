Return-Path: <linux-kernel-owner+w=401wt.eu-S1757655AbYG0GOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655AbYG0GOn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757127AbYG0GOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:14:32 -0400
Received: from main.gmane.org ([80.91.229.2]:38724 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757090AbYG0GOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:14:31 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Nikos Chantziaras <realnc@arcor.de>
Subject: Re: do_IRQ: 0.83/0.84 No irq handler for vector
Date: Sun, 27 Jul 2008 09:14:16 +0300
Message-ID: <g6h3ns$bcl$1@ger.gmane.org>
References: <g6g1ct$6es$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: athedsl-49250.home.otenet.gr
User-Agent: Thunderbird 2.0.0.14 (X11/20080715)
In-Reply-To: <g6g1ct$6es$1@ger.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikos Chantziaras wrote:
> Hello list.
> 
> Kernel 2.6.26 (on x86-64) gives "do_IRQ: 0.83 No irq handler for vector" 
> (and "do_IRQ: 0.83", but less often) warnings periodically.  It seems 
> that the kernel's Radeon DRM driver is at fault, or at least involved 
> (no warnings on a kernel without Radeon DRM).

Sorry, I'll take that back.  It does happen even when compiling 
completely without DRM, so it's probably not related to DRM at all.

