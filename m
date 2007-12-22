Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbXLVQ72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbXLVQ72 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 11:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbXLVQ7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 11:59:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbXLVQ7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 11:59:18 -0500
Message-ID: <476D4259.9020009@redhat.com>
Date: Sat, 22 Dec 2007 11:59:05 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Loic Prylli <loic@myri.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>
Subject: Re: [Fwd: Re: [PATCH 4/5]PCI: x86 MMCONFIG] introduce pcibios_fix_bus_scan_quirk()
References: <fa.HvUNJ45qy60H427u0v9fNt3Gc7E@ifi.uio.no> <fa.zhxdNN/1rfQhfJLVmdGBjvKYrCM@ifi.uio.no> <fa.z1qlON6DA9ubBPFdrEcaFTMgYOY@ifi.uio.no> <fa.U/SCC1Gvd3nSOpkMu5vcsSPYyPE@ifi.uio.no> <fa.d8kGTkzOZH22bXRIRiakqgOPBM4@ifi.uio.no> <fa.pdOcVPk2gFn5iK76ExRH6Ow+NPw@ifi.uio.no> <476D3E3D.80005@shaw.ca>
In-Reply-To: <476D3E3D.80005@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I need to resubmit this patch.

Resubmission will be in my next email.

It was a minor problem whereby the patch would advise the user

	If a device isn't working, try "pci=nommconf".

even when "pci=mmconf" was used at the command line.

One additional line of logic fixed it, but I would like to resubmit
the patch rather than patch the patch.



