Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbXLLNrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbXLLNrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 08:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbXLLNrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 08:47:06 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:60625 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbXLLNrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 08:47:04 -0500
Date: Wed, 12 Dec 2007 14:46:39 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/47] CRIS patches for CRISv32 EtraxFS and ARTPEC-3
Message-ID: <20071212134639.GE3689@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com> <20071212025212.51eed892.akpm@linux-foundation.org> <20071212132842.GA10069@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071212132842.GA10069@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 02:28:42PM +0100, Adrian Bunk wrote:
> On Wed, Dec 12, 2007 at 02:52:12AM -0800, Andrew Morton wrote:
> > On Thu, 29 Nov 2007 17:02:22 +0100 Jesper Nilsson <jesper.nilsson@axis.com> wrote:
> > > The changes are also available in the export2 branch at
> > > 
> > > git://www.jni.nu/axis.git
> > 
> > I don't think there's much point in me merging these.  Please ask Linus to
> > pull that tree once the 2.6.25 merge window opens.
> 
> This sounds reasonable for the arch/cris/ and include/asm-cris/ parts, 
> but shouldn't the rest go through the maintainers?

That would just be the crisv32 serial driver.  I'll send an reworked version
of that patch later on, but it won't be useful until the rest is merged.

> cu
> Adrian

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
