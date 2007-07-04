Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbXGDHer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbXGDHer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 03:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbXGDHej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 03:34:39 -0400
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:40169 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbXGDHei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 03:34:38 -0400
Date: Wed, 4 Jul 2007 16:33:42 +0900
From: Mattia Dongili <malattia@linux.it>
To: Len Brown <lenb@kernel.org>
Cc: trenn@suse.de, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       acpi4asus-user <acpi4asus-user@lists.sourceforge.net>
Subject: Re: [PATCH 3/3] ACPI autoloading - Create __mod_acpi_device_table symbol for all acpi drivers.
Message-ID: <20070704073342.GC8338@inferi.kami.home>
References: <1182112047.4204.12.camel@noname> <20070620170617.GA3226@inferi.kami.home> <1182361643.28514.708.camel@queen.suse.de> <200707030315.33526.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707030315.33526.lenb@kernel.org>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.22-rc4-mm2-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 03:15:33AM -0400, Len Brown wrote:
> 
> > BTW: I also saw a laptop (IIRC it was a sony) with asus and sony ACPI
> > device.
> > When both drivers got loaded things broke.
> > A solution was to only let the asus driver get active if the device is
> > known. Currently, not sure whether still (I sent a patch a while ago),
> > the Asus driver falls back to a default ("M6N"?) configuration. IMO this
> > is a bit too dangerous and instead a message like "unsupported ASUS
> > model found, please send acpidump to linux-acpi@vger.kernel.org".
> 
> This is pretty scary.
> Can you drop the acpidump output into a bugzilla?

and add myself to the cc-list?

thanks
-- 
mattia
:wq!
