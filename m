Return-Path: <linux-kernel-owner+w=401wt.eu-S1751171AbXAXPgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171AbXAXPgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 10:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbXAXPgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 10:36:48 -0500
Received: from mclmx2.mail.saic.com ([149.8.64.32]:38266 "EHLO
	mclmx2.mail.saic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbXAXPgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 10:36:48 -0500
Subject: Re: IO-APIC + timer doesn't work - 2.6.20-rc5 on abit KN9-Ultra
	bios 1.6
From: Eamonn Hamilton <EAMONN.HAMILTON@saic.com>
To: Luming Yu <luming.yu@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <3877989d0701240721lcba4833p76aa14802e3620f7@mail.gmail.com>
References: <1169630914.22508.151.camel@ukabzc383.uk.saic.com>
	 <3877989d0701240721lcba4833p76aa14802e3620f7@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 24 Jan 2007 15:36:16 +0000
Message-Id: <1169652976.22508.178.camel@ukabzc383.uk.saic.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Content-Transfer-Encoding: 7bit
X-ukabzc383-MailScanner: Found to be clean
X-ukabzc383-MailScanner-From: eamonn.hamilton@saic.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I will give that a go tonight - it's my home system.

Cheers,
Eamonn

On Wed, 2007-01-24 at 23:21 +0800, Luming Yu wrote:
> what about acpi=off?
> 
> On 1/24/07, Eamonn Hamilton <EAMONN.HAMILTON@saic.com> wrote:
> > Hi,
> >
> > I can't get any kernel up to 2.6.20-rc5 to boot without using noapic on
> > an ABIT KN9-Ultra with a dual-core Athlon.
> >
> > I booted with apic=debug as suggested and got the following :
> >
> > ENABLING IO-APIC IRQs
> > .. TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
> > .. MP-BIOS bug: 8254 timer not connected to IO-APIC
> > ... trying to set up timer (IRQ0) through the 8252A ... failed
> > ... trying to set up timer as Virtual Wire IRQ ... failed
> > ... trying to set up timer as ExtINT IRQ ... failed :(
> >
> > The bios is the latest, although in various posts on the web it would
> > appear this occurs in older versions also.
> >
> > What can I do to help resolve this?
> >
> > Cheers,
> > Eamonn
> > --
> > Eamonn Hamilton <eamonn.hamilton@saic.com>
> >
> >
> > --
> > This message has been scanned for viruses and
> > dangerous content by MailScanner, and is
> > believed to be clean.
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >


-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

