Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbYHPUtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbYHPUtd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758077AbYHPUrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:47:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:39401 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758571AbYHPUrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:47:39 -0400
Date: Sat, 16 Aug 2008 13:47:52 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, michael_e_brown@dell.com
Subject: Re: [PATCH 2/2] Add Dell laptop driver
Message-ID: <20080816134752.426bdd8a@infradead.org>
In-Reply-To: <20080816203027.GC3331@srcf.ucam.org>
References: <20080816202452.GA3331@srcf.ucam.org>
	<20080816202640.GB3331@srcf.ucam.org>
	<20080816203027.GC3331@srcf.ucam.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2008 21:30:27 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> This driver provides in-kernel control for the backlight and rfkill 
> functionality on Dell laptops. It's based on the publically available 
> information in the libsmbios package.


how does this interact with the backlight control done via ACPI ?


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
