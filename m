Return-Path: <linux-kernel-owner+w=401wt.eu-S1764212AbXHPRH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764212AbXHPRH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 13:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbXHPRHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 13:07:17 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:63267 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256AbXHPRHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 13:07:15 -0400
Date: Thu, 16 Aug 2007 18:07:13 +0100
From: Ben Dooks <ben@fluff.org>
To: Conke Hu <conke.hu@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ben-linux@fluff.org
Subject: Re: [PATCH] nand/s3c2410.c: fix header file include path
Message-ID: <20070816170713.GA31790@fluff.org.uk>
References: <5767b9100708141111ke19e7e5xaa555556e9633f83@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5767b9100708141111ke19e7e5xaa555556e9633f83@mail.gmail.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 02:11:17AM +0800, Conke Hu wrote:
> regs-nand.h and nand.h for s3c nand driver have been moved to plat-s3c/ dir.
> 
> Signed-off-by: conke.hu@gmail.com

This patch is currently awaiting the MTD maintainer to push 
to linus, which should hopefully be next week.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
