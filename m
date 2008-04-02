Return-Path: <linux-kernel-owner+w=401wt.eu-S932795AbYDBUku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795AbYDBUku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763051AbYDBUW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:22:28 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:54611 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763034AbYDBUW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:22:26 -0400
Date: Wed, 2 Apr 2008 16:22:25 -0400
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Frans Pop <elendil@planet.nl>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
Message-ID: <20080402202225.GJ24237@csclub.uwaterloo.ca>
References: <200804021524.27222.elendil@planet.nl> <200804021833.49295.linux@rainbow-software.org> <20080402200549.GC24239@csclub.uwaterloo.ca> <200804022210.26736.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804022210.26736.linux@rainbow-software.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 10:10:23PM +0200, Ondrej Zary wrote:
> I mean S320BIDE.EXE - that's for this machine only.

Hmm, I missed that one.  I wonder how they do it.  Well ISA did support
bus mastering DMA although it seems rare to implement it.  Or it could
be VLB style.

-- 
Len Sorensen
