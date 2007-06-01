Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbXFAWY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbXFAWY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbXFAWYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:24:20 -0400
Received: from terminus.zytor.com ([192.83.249.54]:37327 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbXFAWYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:24:20 -0400
Message-ID: <46609C8B.4000606@zytor.com>
Date: Fri, 01 Jun 2007 15:24:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: DervishD <lkml@dervishd.net>, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kernel utf-8 handling
References: <20070601142058.GA2587@DervishD> <Pine.LNX.4.61.0706012117250.11140@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0706012117250.11140@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> 
> (1) I can do <Compose><~><n> just fine on vt
> (2) I can do <ö> just fine on vt too
> (3) And copy+paste them both using GPM too, again w/o probs
> 

Both of those are in the 0-255 range, though.  I thought the issue was
with characters 256+, like č.  At least on my FC6 system that doesn't
work with gpm.

	-hpa
