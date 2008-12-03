Return-Path: <linux-kernel-owner+w=401wt.eu-S1763096AbYLCUkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763096AbYLCUkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759758AbYLCUee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 15:34:34 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34393 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773AbYLCUec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 15:34:32 -0500
Date: Wed, 3 Dec 2008 20:34:29 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jonathan McDowell <noodles@earth.li>
Cc: corentincj@iksaif.net, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add EEE Bluetooth ACPI details
Message-ID: <20081203203429.GA24103@srcf.ucam.org>
References: <20081203203111.GA28234@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203203111.GA28234@earth.li>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 08:31:11PM +0000, Jonathan McDowell wrote:
> Although rfkill support for the EEE bluetooth device has been added to
> 2.6.28-rc the appropriate ACPI accessor definitions were not added, so
> the support was non functional. The patch below adds the get and set
> accessors and has been verified to work on an EEE 901.
> 
> Signed-off-by: Jonathan McDowell <noodles@earth.li>

Acked-by: Matthew Garrett <mjg@redhat.com>

-- 
Matthew Garrett | mjg59@srcf.ucam.org
