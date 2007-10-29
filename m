Return-Path: <linux-kernel-owner+w=401wt.eu-S1757782AbXJ2Pkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbXJ2Pkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbXJ2Pk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:40:29 -0400
Received: from cavan.codon.org.uk ([78.32.9.130]:51270 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbXJ2Pk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:40:28 -0400
Date: Mon, 29 Oct 2007 15:40:10 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: "lists@antonello.org" <lists@antonello.org>, linux-kernel@vger.kernel.org
Message-ID: <20071029154009.GA28898@srcf.ucam.org>
References: <4724B4F5.80004@antonello.org> <20071028161955.GF23359@auslistsprd01.us.dell.com> <4724CF9F.6050908@antonello.org> <20071028192031.GA11442@auslistsprd01.us.dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071028192031.GA11442@auslistsprd01.us.dell.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Dell laptop backlight driver
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 02:20:31PM -0500, Matt Domsch wrote:

> I've had this discussion on lkml before. Short story is, until Dell
> laptops implement the ACPI methods that the backlight API expects, the
> only sane way to do it is to let libsmbios handle it.  Moving the
> fairly large and complex libsmbios into the kernel isn't a good idea
> (imho).

My understanding was that the current range supported the ACPI methods.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
