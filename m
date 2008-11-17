Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbYKQNdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbYKQNdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYKQNdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:33:32 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:51180 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbYKQNdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:33:31 -0500
Date: Mon, 17 Nov 2008 13:33:25 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Corentin Chary <corentin.chary@gmail.com>, ecc@cmu.edu
Cc: linux acpi <linux-acpi@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: [Patch 0/3] eeepc-laptop updates
Message-ID: <20081117133325.GB12303@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This time with correct addresses...)

This patch series includes patches for the extended hotkeys on the later 
Eees, tidying up some rfkill warnings and making the rfkill PCI hotplug 
work correctly on the current Eees.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
