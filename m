Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbYBWW5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbYBWW5x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 17:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbYBWW5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 17:57:41 -0500
Received: from lixom.net ([66.141.50.11]:39741 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295AbYBWW5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 17:57:41 -0500
Date: Sat, 23 Feb 2008 17:01:26 -0600
From: Olof Johansson <olof@lixom.net>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] scsi fixes for 2.6.25-rc2
Message-ID: <20080223230126.GA23265@lixom.net>
References: <1203779614.3139.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203779614.3139.4.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Feb 23, 2008 at 09:13:33AM -0600, James Bottomley wrote:

> Jeff Garzik (1):
>       mvsas: Add Marvell 6440 SAS/SATA driver
[...]
>  drivers/scsi/mvsas.c                | 2981 ++++++++++++++++++++++++++++++++++++

I just noticed that the file permissions on that file are 755 in current
git, that was probably not intentional?


-Olof
