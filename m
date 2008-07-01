Return-Path: <linux-kernel-owner+w=401wt.eu-S1760416AbYGAWGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760416AbYGAWGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbYGAWF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:05:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:53841 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbYGAWF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:05:56 -0400
Date: Wed, 2 Jul 2008 00:06:01 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] Add btgpio driver
Message-ID: <20080701220601.GA31029@ska.dandreoli.com>
Mail-Followup-To: linux-kernel <linux-kernel@vger.kernel.org>,
	David Brownell <david-b@pacbell.net>
References: <200807010206.38714.mb@bu3sch.de> <20080701010414.GA5279@ska.dandreoli.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701010414.GA5279@ska.dandreoli.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 03:04:15AM +0200, Domenico Andreoli wrote:
> On Tue, Jul 01, 2008 at 02:06:38AM +0200, Michael Buesch wrote:
> > This adds the btgpio driver.
> > The purpose of the btgpio driver is to export all of the 24 GPIO pins
> > available on Brooktree 8xx chips to the kernel GPIO infrastructure.
> > 
> > This makes it possible to use a physically modified BT8xx card as
> > cheap digital GPIO card.
> > 
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> How one is supposed to test this driver? I am unable to switch on
> the GIPO lib support in my config. I tried also allyesconfig but no
> trace of gpio lib stuff.

Really, GPIO menu is no present anywhere. While searching for GPIO
finds stuff, I am unable to locate and select it. I am using 2.6.26-rc8.

regards,
Domenico

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50
