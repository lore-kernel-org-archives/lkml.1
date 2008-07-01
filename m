Return-Path: <linux-kernel-owner+w=401wt.eu-S1760122AbYGABET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbYGABET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 21:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbYGABEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 21:04:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:43747 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779AbYGABEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 21:04:10 -0400
Date: Tue, 1 Jul 2008 03:04:15 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add btgpio driver
Message-ID: <20080701010414.GA5279@ska.dandreoli.com>
Mail-Followup-To: linux-kernel <linux-kernel@vger.kernel.org>
References: <200807010206.38714.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807010206.38714.mb@bu3sch.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 02:06:38AM +0200, Michael Buesch wrote:
> This adds the btgpio driver.
> The purpose of the btgpio driver is to export all of the 24 GPIO pins
> available on Brooktree 8xx chips to the kernel GPIO infrastructure.
> 
> This makes it possible to use a physically modified BT8xx card as
> cheap digital GPIO card.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

How one is supposed to test this driver? I am unable to switch on
the GIPO lib support in my config. I tried also allyesconfig but no
trace of gpio lib stuff.

thanks,
Domenico

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50
