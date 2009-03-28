Return-Path: <linux-kernel-owner+w=401wt.eu-S1758984AbZC1Azf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984AbZC1Azf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 20:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbZC1AzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 20:55:24 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40241 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbZC1AzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 20:55:24 -0400
Date: Sat, 28 Mar 2009 00:55:18 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: Use 32-bit FADT values on X86
Message-ID: <20090328005518.GA4076@srcf.ucam.org>
References: <20090327225225.GA1772@srcf.ucam.org> <alpine.LFD.2.00.0903272045260.26419@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903272045260.26419@localhost.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 08:47:55PM -0400, Len Brown wrote:
> This was already fixed in ACPICA (granted, the patch hasn't gone over the 
> list yet)

Works for me. Thanks!

-- 
Matthew Garrett | mjg59@srcf.ucam.org
