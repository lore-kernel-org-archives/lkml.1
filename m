Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbYJCRKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbYJCRKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 13:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbYJCRK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 13:10:26 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42134 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbYJCRKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 13:10:25 -0400
Date: Fri, 3 Oct 2008 18:10:17 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       rui.zhang@intel.com, pavel@suse.cz
Subject: Re: [PATCH v2] thermal: Make it simpler to use the thermal layer inside the kernel
Message-ID: <20081003171017.GA12820@srcf.ucam.org>
References: <20081001120420.GA29479@srcf.ucam.org> <20081001184111.GA3330@srcf.ucam.org> <200810031908.37618.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810031908.37618.trenn@suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 07:08:36PM +0200, Thomas Renninger wrote:

> grep get_max_state drivers/misc/intel_menlow.c
>         .get_max_state = memory_get_max_bandwidth,

Oops, yeah. I'll fix that one up as well.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
