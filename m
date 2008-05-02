Return-Path: <linux-kernel-owner+w=401wt.eu-S1756966AbYEBETi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbYEBETi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 00:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYEBET1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 00:19:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750821AbYEBET0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 00:19:26 -0400
Date: Thu, 1 May 2008 21:16:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gerhard Mack <gmack@innerfire.net>
Cc: linux-kernel@vger.kernel.org, James Smart <James.Smart@Emulex.Com>,
       linux-scsi@vger.kernel.org
Subject: Re: [2.6.25] lpfc driver problem
Message-Id: <20080501211659.8a2e0686.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0804291625330.31652@mtl.rackplans.net>
References: <alpine.DEB.1.10.0804291625330.31652@mtl.rackplans.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 16:28:03 -0400 (EDT) Gerhard Mack <gmack@innerfire.net> wrote:

> hello
> 
> I'm getting the following error when trying to load the lpfc driver.  This 
> is a new install so I have no idea if this is a regression or not.
> 
> dmesg output:
> Emulex LightPulse Fibre Channel SCSI driver 8.2.5
> Copyright(c) 2004-2008 Emulex.  All rights reserved.
> scsi2 :  on PCI bus 02 device 50 irq 24
> lpfc 0000:02:0a.0: 0:0436 Adapter failed to init, timeout, status reg 
> x400000, FW Data: A8 x0 AC x0
> lpfc 0000:02:0a.0: 0:0436 Adapter failed to init, timeout, status reg 
> x400000, FW Data: A8 x0 AC x0
> 
> Card is:
> 02:0a.0 Fibre Channel: Emulex Corporation LP8000 Fibre Channel Host 
> Adapter (rev 02)
> 02:0a.0 0c04: 10df:f800 (rev 02)

(Cc's added)
