Return-Path: <linux-kernel-owner+w=401wt.eu-S965759AbXAYK1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965759AbXAYK1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 05:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965761AbXAYK1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 05:27:31 -0500
Received: from mclmx2.mail.saic.com ([149.8.64.32]:39468 "EHLO
	mclmx2.mail.saic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965759AbXAYK1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 05:27:30 -0500
Subject: Re: IO-APIC + timer doesn't work - 2.6.20-rc5 on abit KN9-Ultra b
	ios 1.6
From: Eamonn Hamilton <EAMONN.HAMILTON@saic.com>
To: Luming Yu <luming.yu@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <3877989d0701250117j29c04687rbb8214ed5bbb2bbd@mail.gmail.com>
References: <3877989d0701250117j29c04687rbb8214ed5bbb2bbd@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 25 Jan 2007 10:26:59 +0000
Message-Id: <1169720819.22508.208.camel@ukabzc383.uk.saic.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Content-Transfer-Encoding: 7bit
X-ukabzc383-MailScanner: Found to be clean
X-ukabzc383-MailScanner-From: eamonn.hamilton@saic.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

done, bug number #7884

Cheers,
Eamonn

On Thu, 2007-01-25 at 09:17 +0000, Luming Yu wrote:
> > I didn't get a chance to try the -mm patch, but booting with acpi=off
> > works - other than no acpi, of course :)
> >
> > What now?
> Well, this should be ACPI interrupt configure issue.
> Please feel free to enter a bug on bugzilla.kernel.org.
> And, post acpidump output, /proc/interrupts ,lspci -vvx, dmesg for
> (acpi=off ) there.
> 
> Thanks,
> Luming


-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

