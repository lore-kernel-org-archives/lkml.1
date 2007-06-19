Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbXFSQYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbXFSQYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 12:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755648AbXFSQXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 12:23:55 -0400
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:36707 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbXFSQXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 12:23:54 -0400
Date: Wed, 20 Jun 2007 01:23:29 +0900
From: Mattia Dongili <malattia@linux.it>
To: Thomas Renninger <trenn@suse.de>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Len Brown <lenb@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Kay Sievers <kasievers@suse.de>
Subject: Re: [PATCH 3/3] ACPI autoloading - Create __mod_acpi_device_table symbol for all acpi drivers.
Message-ID: <20070619162329.GB3281@inferi.kami.home>
References: <1182111863.4204.6.camel@noname> <20070617224947.GA17951@khazad-dum.debian.net> <1182257607.28514.643.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182257607.28514.643.camel@queen.suse.de>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.22-rc5-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 02:53:27PM +0200, Thomas Renninger wrote:
> On Sun, 2007-06-17 at 19:49 -0300, Henrique de Moraes Holschuh wrote:
> > On Sun, 17 Jun 2007, Thomas Renninger wrote:
> > > Create __mod_acpi_device_table symbol for all acpi drivers.
...
> > model-specific drivers like thinkpad-acpi
> Not in general, only if the driver provides additional functions and the
> ACPI device does not appear on machines that need those additional
> functions.
> E.g. the asus driver AFAIK serves exactly the ACPI device it registers
> for.

and the sony-laptop as well. Thanks for doing that, will test as soon as
possible on my vaios here.

-- 
mattia
:wq!
