Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbZDTPsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbZDTPsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 11:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbZDTPrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 11:47:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38234 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755746AbZDTPry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 11:47:54 -0400
Date: Mon, 20 Apr 2009 17:47:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Niels de Vos <niels.devos@wincor-nixdorf.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [trivial] serial: remove contact data
In-Reply-To: <49E49E25.6060601@wincor-nixdorf.com>
Message-ID: <alpine.LNX.2.00.0904201747440.13028@wotan.suse.de>
References: <49E49E25.6060601@wincor-nixdorf.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009, Niels de Vos wrote:

> Remove my name and emailaddress from note in the source. Wincor Nixdorf
> only has some ITE-chips on their mainboards, other chips are not
> available for me for testing.
> 
> Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>
> ---
>  drivers/serial/8250_pci.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
> index 533f820..9d646b0 100644
> --- a/drivers/serial/8250_pci.c
> +++ b/drivers/serial/8250_pci.c
> @@ -612,8 +612,6 @@ static int pci_netmos_init(struct pci_dev *dev)
>  }
>  
>  /*
> - * ITE support by Niels de Vos <niels.devos@wincor-nixdorf.com>
> - *
>   * These chips are available with optionally one parallel port and up to
>   * two serial ports. Unfortunately they all have the same product id.
>   *

Applied to trivial tree, thanks.

-- 
Jiri Kosina
SUSE Labs
