Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbXJ3Cag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbXJ3Cag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 22:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbXJ3Ca2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 22:30:28 -0400
Received: from cavan.codon.org.uk ([78.32.9.130]:55943 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbXJ3Ca1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 22:30:27 -0400
Date: Tue, 30 Oct 2007 02:30:13 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam Belay <ambx1@neo.rr.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>
Message-ID: <20071030023012.GA6014@srcf.ucam.org>
References: <200710291525.31475.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710291525.31475.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [RFC] [PATCH] PNP: request ioport and iomem resources used by active devices
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 03:25:31PM -0600, Bjorn Helgaas wrote:
> Reserve resources used by active PNP devices to prevent those resources
> from being assigned to other devices.

Yes, I think this is probably a safe approach to take.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
