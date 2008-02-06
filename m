Return-Path: <linux-kernel-owner+w=401wt.eu-S1762836AbYBFAni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762836AbYBFAni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 19:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760169AbYBFAn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 19:43:27 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:8191 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759256AbYBFAn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 19:43:26 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH for review] ACPI: Create /sys/firmware/acpi/interrupts/ counters
Date: Tue, 5 Feb 2008 17:44:36 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Greg KH <gregkh@suse.de>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200802050230.10873.lenb@kernel.org> <20080205221805.GC6950@suse.de> <200802051812.09228.lenb@kernel.org>
In-Reply-To: <200802051812.09228.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802051744.36371.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2008 04:12:09 pm Len Brown wrote:
> is there
> a version of cat that prints the file name before
> the contents of each file?

I use "grep . *" for this sort of thing.
