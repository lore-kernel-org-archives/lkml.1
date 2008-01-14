Return-Path: <linux-kernel-owner+w=401wt.eu-S1755809AbYANBvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbYANBvi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 20:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbYANBv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 20:51:29 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:51315 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbYANBv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 20:51:27 -0500
Date: Mon, 14 Jan 2008 01:51:21 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, len.brown@intel.com
Message-ID: <20080114015121.GB2317@srcf.ucam.org>
References: <20071226020325.GA21099@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071226020325.GA21099@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Rationalise ACPI backlight implementation
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len, I've had no feedback on this - the backlight maintainer thinks it's 
the right way to go, so I'd like to get it queued for .25 at least.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
