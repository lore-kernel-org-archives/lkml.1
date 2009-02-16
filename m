Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135AbZBPPWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbZBPPWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 10:22:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbZBPPVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 10:21:24 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:38930 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbZBPPVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 10:21:23 -0500
Date: Mon, 16 Feb 2009 15:21:20 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alexandre Rostovtsev <tetromino@gmail.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lenovo-sl-laptop : driver for review
Message-ID: <20090216152120.GA5018@srcf.ucam.org>
References: <20090216025918.66d7a466@leftboat.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216025918.66d7a466@leftboat.lan>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, yeah, is there really no notification when a hotkey is pressed? 
Polling is somewhat hostile to power management.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
