Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbYK2EvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbYK2EvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 23:51:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbYK2Euz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 23:50:55 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34797 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbYK2Euz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 23:50:55 -0500
Date: Sat, 29 Nov 2008 04:50:45 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Brian S. Julin" <bri@abrij.org>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] misc: Add oqo-wmi driver for model 2 OQO backlight and rfkill control
Message-ID: <20081129045045.GA13866@srcf.ucam.org>
References: <20081127190517.GA25429@srcf.ucam.org> <alpine.LFD.2.00.0811281431320.3204@localhost.localdomain> <Pine.LNX.4.64.0811282215160.17453@sheavy.abrij.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811282215160.17453@sheavy.abrij.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2008 at 10:35:17PM -0500, Brian S. Julin wrote:
> On Fri, 28 Nov 2008, Len Brown wrote:
> >needs a MAINTAINERS entry.
> 
> If it were to be set to me it would have to be S: Odd Fixes.  I don't know 
> if this
> is on Matthew's redhat-official "pile of laptops"...

Somewhat. There's some work to be done on getting X to work out the LVDS 
sizing correctly, but other than that I think I get to play with it for 
now...

> Either way I've marked the webpage hosting the original code as depricated 
> and added a link to linux-acpi's home.  I'll have to test the new patch too 
> at some point but not this weekend.

Cool, thanks. I'll have more time to work on the hardware the week after 
next.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
