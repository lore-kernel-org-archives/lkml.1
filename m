Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbZFWSm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbZFWSm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 14:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbZFWSly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 14:41:54 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:46008 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbZFWSlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 14:41:53 -0400
Date: Tue, 23 Jun 2009 14:41:28 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 2.6.32] Simple Firmware Interface (SFI): initial support
In-reply-to: <20090623183153.GB12814@srcf.ucam.org>
Message-id: <alpine.LFD.2.00.0906231438190.23079@localhost.localdomain>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org>
 <20090623183153.GB12814@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Matthew Garrett wrote:

> There seems to be a huge amount of overlap between SFI and ACPI.
> Couldn't this have simply taken the form of some additional ACPI tables 
> and a decoupling of ACPI enumeration from runtime AML interpretation? 
> How final is this spec?

> I realise that we're pretty much constrained to implementing this if 
> hardware actually ships with it, but it seems to be an additional 
> firmware interface with no real benefit - as far as I can tell it's not 
> possible for a platform to meaningfully implement both ACPI and SFI 
> without duplicating information?

Please let me know if your questions are not thoroughly answered here:
http://simplefirmware.org/faq

thanks,
-Len Brown, Intel Open Source Technology Center

