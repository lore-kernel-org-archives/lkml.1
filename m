Return-Path: <linux-kernel-owner+w=401wt.eu-S932914AbXBTMWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914AbXBTMWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 07:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932913AbXBTMWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 07:22:49 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:45529 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909AbXBTMWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 07:22:48 -0500
Date: Tue, 20 Feb 2007 12:22:38 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Dale Farnsworth <dale@farnsworth.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, Jeff Garzik <jgarzik@pobox.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Eliminate user-selectable CONFIG_MV643XX_ETH_[012]
Message-ID: <20070220122238.GA27855@linux-mips.org>
References: <20070220121520.GA17927@xyzzy.farnsworth.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220121520.GA17927@xyzzy.farnsworth.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 05:15:20AM -0700, Dale Farnsworth wrote:

> From: Dale Farnsworth <dale@farnsworth.org>
> 
> Remove the use of CONFIG_MV643XX_ETH_[012] variables on most
> platforms.  Instead, platform-specific code enables the ports
> supported by the hardware.  After this patch, these config
> variables are only used in arch/ppc, so also move them from
> drivers/net/Kconfig to arch/ppc/Kconfig.
> 
> Signed-off-by: Dale Farnsworth <dale@farnsworth.org>

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
