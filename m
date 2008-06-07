Return-Path: <linux-kernel-owner+w=401wt.eu-S1758409AbYFGJ6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409AbYFGJ6v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 05:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbYFGJ6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 05:58:43 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42641 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbYFGJ6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 05:58:43 -0400
Date: Sat, 7 Jun 2008 10:58:39 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org, mzxreary@0pointer.de
Subject: Re: [PATCH] Add backlight driver for Nvidia-based Apple Macbook Pros
Message-ID: <20080607095839.GA803@srcf.ucam.org>
References: <20080607025436.GB24254@srcf.ucam.org> <20080606230745.304d116b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606230745.304d116b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 11:07:45PM -0700, Andrew Morton wrote:
> On Sat, 7 Jun 2008 03:54:36 +0100 Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > + *  Copyright (C) 2006 Nicolas Boichat <nicolas @boichat.ch>
> > + *  Copyright (C) 2006 Felipe Alfaro Solana <felipe_alfaro @linuxmail.org>
> > + *  Copyright (C) 2007 Julien BLACHE <jb@jblache.org>
> 
> Did this patch have appropriate attribution and signoffs?

Pommed is GPLv2.

> Missing release_region()?

Yup.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
