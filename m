Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbZDHWJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbZDHWJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 18:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbZDHWJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 18:09:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50518 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbZDHWJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 18:09:22 -0400
Date: Wed, 8 Apr 2009 18:09:21 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-parisc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.30-rc1: parisc: system hangs on boot at __schedule()
Message-ID: <20090408220921.GF7372@bombadil.infradead.org>
References: <a4423d670904080603w50face2fl87cd16bd7967cb5d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670904080603w50face2fl87cd16bd7967cb5d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 05:03:04PM +0400, Alexander Beregalov wrote:
> Hi
> 
> Machine is HP j6000.
> CPU(s): 2 x PA8700 (PCX-W2) at 750.000000 MHz
> 
> gcc version 4.3.3 (Gentoo 4.3.3-r2 p1.1, pie-10.1.5)
> 
> 
> Machine hangs before starting rc scripts, but SysRq and C-A-Del work.
> 
> All tasks are at __schedule+0x268/0x7bc:
> 

.config?
