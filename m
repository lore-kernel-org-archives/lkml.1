Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbZDMTn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbZDMTn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 15:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbZDMTnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 15:43:49 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59434 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZDMTns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 15:43:48 -0400
Date: Mon, 13 Apr 2009 20:43:41 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-acpi@vger.kernel.org, dsilvers@simtec.co.uk,
       toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org, lenb@intel.com
Subject: Re: [PATCH 1/2] toshiba-acpi: Add support for hotkey notifications
Message-ID: <20090413194341.GA16579@srcf.ucam.org>
References: <20090331214501.GC29489@srcf.ucam.org> <200904112150.38010.elendil@planet.nl> <20090413145015.GA10976@srcf.ucam.org> <200904132128.54769.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904132128.54769.elendil@planet.nl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hm. Do you get events for the multimedia keys without this patch and 
using the old interface?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
