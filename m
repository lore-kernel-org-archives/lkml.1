Return-Path: <linux-kernel-owner+w=401wt.eu-S1763277AbXHPOt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763277AbXHPOt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 10:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758095AbXHPOtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 10:49:19 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:50680 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757755AbXHPOtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 10:49:18 -0400
Date: Thu, 16 Aug 2007 10:48:41 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Nicolas George <nicolas.george@normalesup.org>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH] UML: BLKGETSIZE takes a long, not an int
Message-ID: <20070816144841.GC6670@c2.user-mode-linux.org>
References: <20070813124247.GA7414@she-seel.salle-s.org> <20070815171247.GA7948@c2.user-mode-linux.org> <20070815213825.GA26490@clipper.ens.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070815213825.GA26490@clipper.ens.fr>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 11:38:25PM +0200, Nicolas George wrote:
> Here is the hopefully correct patch, against current git.

Thanks, I'll forward it upstream.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
