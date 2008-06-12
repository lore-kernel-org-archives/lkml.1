Return-Path: <linux-kernel-owner+w=401wt.eu-S1760958AbYFLMe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760958AbYFLMe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758701AbYFLMeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:34:19 -0400
Received: from vigor.karmaclothing.net ([217.169.26.28]:38838 "EHLO
	vigor.karmaclothing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569AbYFLMeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:34:19 -0400
Date: Thu, 12 Jun 2008 13:26:46 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Manuel Lauss <mano@roarinelk.homelinux.net>
Cc: linux-mips@linux-mips.org, sshtylyov@ru.mvista.com, drzeus@drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] Alchemy: register mmc platform device for
	db1200/pb1200 boards.
Message-ID: <20080612122646.GA9493@linux-mips.org>
References: <20080609063521.GA8724@roarinelk.homelinux.net> <20080609063702.GC8724@roarinelk.homelinux.net> <20080612090206.GB21601@linux-mips.org> <20080612101839.GC21601@linux-mips.org> <20080612121828.GA24603@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080612121828.GA24603@roarinelk.homelinux.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 02:18:28PM +0200, Manuel Lauss wrote:

> Hi Ralf, Pierre,
> 
> On Thu, Jun 12, 2008 at 11:18:39AM +0100, Ralf Baechle wrote:
> > On Thu, Jun 12, 2008 at 10:02:06AM +0100, Ralf Baechle wrote:
> > 
> > I cleaned the numerals for the DMA constants with below patch which now
> > is in the 2.6.27 patch queue.
> 
> Here's a new version of [PATCH 2/8], against those changes.

Thanks, looking good, thus:

Acked-by: Ralf Baechl <ralf@linux-mips.org>

Pierre, feel free to merge these MIPS bits into your tree.  The whole
series should probably go upstream together.

  Ralf
