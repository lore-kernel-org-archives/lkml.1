Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbXEZHxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbXEZHxQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 03:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbXEZHxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 03:53:09 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:47030 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbXEZHxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 03:53:08 -0400
Date: Sat, 26 May 2007 00:53:07 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: Jeff Garzik <jeff@garzik.org>
cc: linux-ide@vger.kernel.org, Dave Dillow <dave@thedillows.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFT, v4] sata_mv: convert to new EH
In-Reply-To: <4657A678.8090308@garzik.org>
Message-ID: <Pine.LNX.4.64.0705252335590.8327@twinlark.arctic.org>
References: <20070225233454.GA31282@havoc.gtf.org> 
 <1173158201.3416.8.camel@obelisk.thedillows.org>  <45ED039E.20608@garzik.org>
 <1173164261.3416.15.camel@obelisk.thedillows.org> <4656EB26.40504@garzik.org>
 <4657A678.8090308@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007, Jeff Garzik wrote:

> Already uncovered and fixed a few bugs in v3.
> 
> Here's v4 of the sata_mv new-EH patch.

you asked for test results with 2.6.21.3 ... that seems to boot fine,
and i've tested reading from the disks only and it seems to be working
fine.  ditto for 2.6.22-rc3.

but 2.6.22-rc3 + your v4 patch fails... i'll send you the serial console
outputs offline.

-dean




