Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbXKFK4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbXKFK4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 05:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbXKFK4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 05:56:25 -0500
Received: from nic2.axis.se ([193.13.178.10]:41964 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbXKFK4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 05:56:25 -0500
Date: Tue, 6 Nov 2007 11:56:19 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: a list of non-existent but included include/linux header files
Message-ID: <20071106105619.GB5433@axis.com>
References: <Pine.LNX.4.64.0711052327090.6602@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711052327090.6602@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 11:31:39PM -0500, Robert P. J. Day wrote:
> === Missing: include/linux/mtd/mtdram.h ===
> arch/cris/arch-v32/drivers/axisflashmap.c:#include <linux/mtd/mtdram.h>
> arch/cris/arch-v10/drivers/axisflashmap.c:#include <linux/mtd/mtdram.h>

The above headerfile should be in the queue for inclusion.

> Robert P. J. Day

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
