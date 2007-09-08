Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbXIHTPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbXIHTPN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 15:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbXIHTO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 15:14:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51902 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbXIHTO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 15:14:59 -0400
Date: Sat, 8 Sep 2007 21:14:57 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andi Kleen <andi@firstfloor.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
Message-ID: <20070908191457.GB8647@one.firstfloor.org>
References: <20070907124800.GP16806@vanheusden.com> <p73fy1p9m57.fsf@bingen.suse.de> <20070908095008.08eb4930.randy.dunlap@oracle.com> <20070908181309.GA8647@one.firstfloor.org> <46E2EA2E.6020002@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E2EA2E.6020002@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2007 at 08:30:06PM +0200, Stefan Richter wrote:
> Andi Kleen wrote:
> > when you've been using CONFIG_IDE before it is not completely
> > obvious you need BLK_SD for your hard disk.
> 
> Switching to different drivers without reading the help text?
> Tough.

The individual driver descriptions don't say BLK_SD needs to be selected.

Besides if all descriptions said that the computer could as well
do it for the user automatically. After all it's a stupid repetive
task and computers are much better at those than humans.

-Andi
