Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbZDMOxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbZDMOxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 10:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbZDMOxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 10:53:43 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55399 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbZDMOxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 10:53:42 -0400
Date: Mon, 13 Apr 2009 15:53:34 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Alexey Starikovskiy <aystarik@gmail.com>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [BISECTED] 20 ACPI interrupts per second on EEEPC 4G
Message-ID: <20090413145334.GB10976@srcf.ucam.org>
References: <49DF6835.9040501@tuffmail.co.uk> <49DFE345.3010109@gmail.com> <49E05F83.2090500@tuffmail.co.uk> <49E20EBA.2090708@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E20EBA.2090708@tuffmail.co.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 12, 2009 at 04:54:34PM +0100, Alan Jenkins wrote:

> I did wonder whether this was due to thermal polling.  So look what I
> found with bisection :-).

Huh. Could you send me the acpidump output?
-- 
Matthew Garrett | mjg59@srcf.ucam.org
