Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbYH0OGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbYH0OGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757441AbYH0Nyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:54:31 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50657 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880AbYH0Ny2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:54:28 -0400
Date: Wed, 27 Aug 2008 14:54:18 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Sven Wegener <sven.wegener@stealer.net>,
       Bob Moore <robert.moore@intel.com>, Andi Kleen <ak@linux.intel.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: acer-wmi broken in latest git kernel on TravelMate 6492 (Insufficient arguments - method [WQAA])
Message-ID: <20080827135418.GB7162@srcf.ucam.org>
References: <alpine.LNX.1.10.0808021640310.2294@titan.stealer.net> <200808021728.46046.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808021728.46046.carlos@strangeworlds.co.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2008 at 05:28:45PM +0100, Carlos Corbacho wrote:
> ACPI: WMI: Set instance for query block calls
> 
> From: Carlos Corbacho <carlos@strangeworlds.co.uk>
> 
> Although the necessary data structure was set up, it was never actually
> passed in, so data block calls have only been working by sheer chance.

Hm. Has this gone upstream? Looks pretty important for .27.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
