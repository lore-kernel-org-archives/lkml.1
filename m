Return-Path: <linux-kernel-owner+w=401wt.eu-S1760641AbZBDNfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760641AbZBDNfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757786AbZBDN0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 08:26:33 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:26281 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756AbZBDN0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 08:26:32 -0500
Date: Wed, 4 Feb 2009 14:26:06 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Len Brown <lenb@kernel.org>,
       Luca Tettamanti <kronos.it@gmail.com>, Thomas Renninger <trenn@suse.de>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: add "auto" to acpi_enforce_resources
Message-ID: <20090204142606.1823661b@hyperion.delvare>
In-Reply-To: <20090204131708.GA2739@srcf.ucam.org>
References: <20090125210520.GA12963@dreamland.darkstar.lan>
	<200901291130.35434.trenn@suse.de>
	<68676e00901290716g1aabd6c0p1e5202fbdbc659a4@mail.gmail.com>
	<alpine.LFD.2.00.0902040042570.9833@localhost.localdomain>
	<20090204060513.GA28321@srcf.ucam.org>
	<498953DF.5050306@redhat.com>
	<20090204131708.GA2739@srcf.ucam.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

On Wed, 4 Feb 2009 13:17:09 +0000, Matthew Garrett wrote:
> On Wed, Feb 04, 2009 at 09:37:51AM +0100, Hans de Goede wrote:
> 
> > Len, Matthew, what is you opinion of the proposed auto setting for 
> > acpi_enforce_resources, which is meant to mean strict on known problematic 
> > systems and lax on others?
> 
> Personally, I'd rather that it was "strict" on everything. We might 
> break some existing setups, but they're already working mostly by luck.

Are you the new hwmon and i2c subsystems maintainer and I wasn't aware
of it?

-- 
Jean Delvare
