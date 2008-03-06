Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbYCFRTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbYCFRTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 12:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbYCFRS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 12:18:56 -0500
Received: from de01egw02.freescale.net ([192.88.165.103]:63431 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbYCFRSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 12:18:55 -0500
Date: Thu, 6 Mar 2008 10:05:42 -0600
From: Scott Wood <scottwood@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Vitaly Bordug <vitb@kernel.crashing.org>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [POWERPC] 8xx: fix swap
Message-ID: <20080306160542.GB958@ld0162-tx32.am.freescale.net>
References: <20080306135330.6d5462d2@vitb.ru.mvista.com> <7E836D6E-867B-4A35-9B3D-CD1D52E7F2DC@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7E836D6E-867B-4A35-9B3D-CD1D52E7F2DC@kernel.crashing.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 09:56:58AM -0600, Kumar Gala wrote:
> On Mar 6, 2008, at 4:53 AM, Vitaly Bordug wrote:
> > arch/powerpc/kernel/head_8xx.S      |   30 ++++++++++++++++++++++++++ 
> > +++-
> > include/asm-powerpc/pgtable-ppc32.h |    8 --------
> > 2 files changed, 29 insertions(+), 9 deletions(-)
> 
> do we need similar fixes to arch/ppc ?

Yes, a patch was posted a while ago.

-Scott
