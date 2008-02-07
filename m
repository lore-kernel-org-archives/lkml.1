Return-Path: <linux-kernel-owner+w=401wt.eu-S933700AbYBGW2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700AbYBGW2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757874AbYBGW2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:28:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:40066 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758033AbYBGW2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:28:00 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: ACPI_WMI: worst config description of all times
Date: Thu, 7 Feb 2008 17:27:38 -0500
User-Agent: KMail/1.9.5
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       linux-acpi@vger.kernel.org
References: <20080207214715.GA15211@elf.ucw.cz>
In-Reply-To: <20080207214715.GA15211@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802071727.38743.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2008 16:47, Pavel Machek wrote:
> 
> See? It even has completely useless help text.
> 
> Does WMI stand for Windows Management Instrumentation? It is some
> server management feature? What is it good for?

Thank you for the feedback, Pavel.

There is an additional patch which creates
Documentation/acpi/wmi.txt, but I witheld it from
this batch because it needs to be revised.
If you are not subscribed to the linux-acpi list
you can find it here:

http://marc.info/?l=linux-acpi&m=120217838010224&w=2

Clearly we neeed to update the Kconfig doc as well when
we revise and push that patch.

-Len

ps. the answers to your questions are "yes" and "see NOTE" below.

>   WMI (EXPERIMENTAL) (ACPI_WMI) [N/m/y/?] (NEW) ?
> 
> This driver adds support for the ACPI-WMI mapper device (PNP0C14)
> found on some systems.
> 
> NOTE: You will need another driver or userspace application on top of
> this to actually use anything defined in the ACPI-WMI mapper.
> 
> 
