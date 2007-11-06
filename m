Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbXKFON3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbXKFON3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 09:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbXKFONW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 09:13:22 -0500
Received: from lazybastard.de ([212.112.238.170]:41445 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbXKFONV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 09:13:21 -0500
Date: Tue, 6 Nov 2007 15:08:31 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: a list of non-existent but included include/linux header files
Message-ID: <20071106140830.GG25953@lazybastard.org>
References: <Pine.LNX.4.64.0711052327090.6602@localhost.localdomain> <20071106105619.GB5433@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071106105619.GB5433@axis.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 November 2007 11:56:19 +0100, Jesper Nilsson wrote:
> On Mon, Nov 05, 2007 at 11:31:39PM -0500, Robert P. J. Day wrote:
> > === Missing: include/linux/mtd/mtdram.h ===
> > arch/cris/arch-v32/drivers/axisflashmap.c:#include <linux/mtd/mtdram.h>
> > arch/cris/arch-v10/drivers/axisflashmap.c:#include <linux/mtd/mtdram.h>
> 
> The above headerfile should be in the queue for inclusion.

It is.  I was already wondering what might be using it.

Jörn

-- 
To my face you have the audacity to advise me to become a thief - the worst
kind of thief that is conceivable, a thief of spiritual things, a thief of
ideas! It is insufferable, intolerable!
-- M. Binet in Scarabouche
