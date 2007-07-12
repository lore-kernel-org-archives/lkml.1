Return-Path: <linux-kernel-owner+w=401wt.eu-S934559AbXGLUbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934559AbXGLUbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 16:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758702AbXGLUbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 16:31:42 -0400
Received: from ptb-relay03.plus.net ([212.159.14.214]:47493 "EHLO
	ptb-relay03.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758384AbXGLUbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 16:31:41 -0400
Subject: Re: Hard drive - dead or dying?
From: David Sumbler <david@aeolia.co.uk>
Reply-To: david@aeolia.co.uk
To: Mark Lord <lkml@rtr.ca>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46962E09.40606@rtr.ca>
References: <1184222444.5969.0.camel@ceres>  <46962E09.40606@rtr.ca>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 21:31:39 +0100
Message-Id: <1184272299.5965.4.camel@ceres>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 09:35 -0400, Mark Lord wrote:
> David Sumbler wrote:
> > My computer (Ubuntu Feisty) would not boot correctly a few days
> > ago: it seemed to get into a loop with the following printed about
> > every 7 seconds (all laboriously copied in longhand, since it wasn't
> > logged!):
> > 
> > ata1.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> > ata1.01: (BMDMA stat 0x65)
> > ata1.01: cmd c8/00:08:80:b4:a8/00:00:00:00:00/f4 tag0 cdb 0x0 data 4096
> > in
> >          res 51/01:08:80:b4:a8/00:00:00:00:00/f4 Emark 0x1 (device error)
> 
> Use 'smartctl' to find out what the drive is having issues with.

Unfortunately I cannot boot the computer unless the drive in question is
disconnected.

David

-- 
David Sumbler <david@aeolia.co.uk>

