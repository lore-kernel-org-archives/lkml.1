Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbZHKXtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbZHKXtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 19:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932153AbZHKXtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 19:49:15 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45187 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbZHKXtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 19:49:14 -0400
Date: Wed, 12 Aug 2009 00:49:09 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       matthew.tippett@amd.com, samuel.li@amd.com
Subject: Re: [PATCH][ACPI] AC/DC notifier
Message-ID: <20090811234909.GA30174@srcf.ucam.org>
References: <200908111515.42635.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908111515.42635.mark.langsdorf@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 03:15:42PM -0500, Mark Langsdorf wrote:
> Add an ACPI event notifier for AC/DC connect/disconnect events.

Not that I inherently disagree with this, but what's it likely to be 
used for?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
