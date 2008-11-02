Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbYKBNhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbYKBNhP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 08:37:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbYKBNgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 08:36:46 -0500
Received: from isilmar.linta.de ([213.133.102.198]:54579 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753354AbYKBNgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 08:36:44 -0500
Date: Sun, 2 Nov 2008 13:04:34 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Komuro <komurojun-mbn@nifty.com>
Cc: torvalds@osdl.org, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [BUG REPORT!!!] [PATCH 19/49] pcmcia: remove remaining
	in-kernel pcmcia_get_configuration_info() users
Message-ID: <20081102120434.GA14531@comet.dominikbrodowski.net>
Mail-Followup-To: Komuro <komurojun-mbn@nifty.com>, torvalds@osdl.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20080922155814.2bdad40f@lxorguk.ukuu.org.uk> <20080922215617.GA13057@comet.dominikbrodowski.net> <20080922231227.2625dd09@lxorguk.ukuu.org.uk> <20080922222655.GA3792@isilmar.linta.de> <20081101110746.41733076.komurojun-mbn@nifty.com> <20081102174622.02500138.komurojun-mbn@nifty.com> <20081102091756.GA25322@isilmar.linta.de> <20081102193324.86f0d4a3.komurojun-mbn@nifty.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081102193324.86f0d4a3.komurojun-mbn@nifty.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2008 at 07:33:24PM +0900, Komuro wrote:
> 
> drivers/pcmcia/ds.c
> 
> setup "io" and "irq" for pseudo multifunction devices.

Applied, thanks!

