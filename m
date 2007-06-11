Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbXFKM1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbXFKM1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 08:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbXFKM1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 08:27:42 -0400
Received: from mail.suse.de ([195.135.220.2]:43361 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbXFKM1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 08:27:41 -0400
Date: Mon, 11 Jun 2007 12:45:32 +0200
From: Stefan Seyfried <seife@suse.de>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: 2.6.22-rc regression: s2ram fails to suspend + fails to resume w/ Xorg
Message-ID: <20070611104532.GA6289@suse.de>
References: <1181493847.4503.11.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1181493847.4503.11.camel@localhost>
X-Operating-System: openSUSE 10.3 (i586) Alpha4plus, Kernel 2.6.22-rc3-git2-5-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2007 at 06:44:07PM +0200, Soeren Sonnenburg wrote:
> Dear all,
> 
> I noticed 2 regressions to 2.6.21.X on my macbook pro:
> 
> 1. on git-current something broke s2ram completely, i.e. s2ram does not
> even suspend anymore but hangs (blinking cursor on console)

I have had a report, where "vga=0" (instead of using vesafb) worked
around a similar issue on a macbook. I don't know the kernel version, though.
-- 
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg  | "Well, surrounding them's out." 

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
