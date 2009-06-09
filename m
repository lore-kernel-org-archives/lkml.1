Return-Path: <linux-kernel-owner+w=401wt.eu-S1758464AbZFIHMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464AbZFIHMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 03:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756838AbZFIHMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 03:12:35 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:57465 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbZFIHMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 03:12:35 -0400
Date: Tue, 9 Jun 2009 01:12:35 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: linux-arm-kernel@lists.arm.linux.org.uk
cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 00/10] OMAP clock/powerdomain/SDRC patches for
 post-2.6.30
In-Reply-To: <20090526220517.25381.75976.stgit@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0906090110580.32281@utopia.booyaka.com>
References: <20090526220517.25381.75976.stgit@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On Tue, 26 May 2009, Paul Walmsley wrote:

> here is the next set of OMAP clock patches for review for the
> post-2.6.30 merge window.  They apply on top of the previous set
> ("OMAP clock/SDRC patches on v2.6.30-rc5").  If you're happy with
> these patches, Tony will queue them up into his for-next branch.
> 
> This series completes basic support for OMAP3 CORE DVFS.  A few other
> minor bugs are fixed by the off-by-one patch and the GPIO debounce
> clock patch.

Any comments on these patches?


- Paul
