Return-Path: <linux-kernel-owner+w=401wt.eu-S1761739AbXG2LvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761739AbXG2LvR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 07:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbXG2LvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 07:51:06 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47627 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752762AbXG2LvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 07:51:05 -0400
Date: Sun, 29 Jul 2007 13:50:40 +0200
From: Adrian Bunk <bunk@stusta.de>
To: spyro@f2s.com, john@dnsworld.co.uk
Cc: linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk
Subject: RFC: Remove the arm26 port
Message-ID: <20070729115040.GD30976@stusta.de>
References: <20070707201208.GJ3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070707201208.GJ3492@stusta.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Considering the state of the arm26 port, I do hereby suggest to remove 
it from the Linx kernel since it's far from a usable state and doesn't 
seem to come back into a usable state.

If anyone wants to work on getting this port back into a usable state in 
the forseeable future he should speak up now.

cu
Adrian


On Sat, Jul 07, 2007 at 10:12:08PM +0200, Adrian Bunk wrote:

> I'm wondering what the status of the arm26 port in the kernel is:
> 
> AFAIR gcc support for this architecture was deprecated in gcc 3.4 and 
> removed in gcc 4.0. This implies that either someone will have to re-add 
> support to gcc in the next 1-2 years or the kernel port will become 
> useless with the next increase of the minimum gcc requirement for the 
> kernel.
> 
> The other point is that I tried to cross-compile an arm26 defconfig.
> I gave up after running into several compile errors, and it doesn't seem 
> as if any recent kernel could be compiled.
> 
> Is the arm26 kernel port already unused dead code or is some work for 
> getting it back into shape pending?
> 
> cu
> Adrian
