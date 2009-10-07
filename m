Return-Path: <linux-kernel-owner+w=401wt.eu-S1759208AbZJGOHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208AbZJGOHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880AbZJGOHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:07:16 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42168 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbZJGOHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:07:15 -0400
Date: Wed, 7 Oct 2009 15:05:41 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Tippett, Matthew" <matthew.tippett@amd.com>,
       Willy Tarreau <w@1wt.eu>, "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       lenb@kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Li, Samuel" <Samuel.Li@amd.com>
Subject: Re: [PATCH][ACPI] AC/DC notifier
Message-ID: <20091007140541.GB12756@srcf.ucam.org>
References: <FFAE0590FF35E441901B67BD8BA62E950245ABD9@storexmb3.amd.com> <20090812005532.GA31003@srcf.ucam.org> <20090814163233.GC1626@ucw.cz> <20090816074008.GA11624@1wt.eu> <4ACB59E2.3000600@amd.com> <20091007073121.GA31245@elf.ucw.cz> <21d7e9970910070116h6cf4e472i309537e9b4bb1e08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970910070116h6cf4e472i309537e9b4bb1e08@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 06:16:29PM +1000, Dave Airlie wrote:

> I'm not sure we have a open driver use case for this, if not I suggest
> we remove it and only add it when a user is added to the kernel.

We'll need it once we add scaling support to radeon, so I don't see the 
harm with it being merged now.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
