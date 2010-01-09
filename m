Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891Ab0AIU0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab0AIU0s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 15:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664Ab0AIU0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 15:26:47 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:39927 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab0AIU0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 15:26:47 -0500
Date: Sat, 9 Jan 2010 20:26:42 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Peter Paul <abnominales@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ACPI quirks - acpi_osi="!Windows 2006" required on FSC Amilo
	notebooks to enable brightness keys
Message-ID: <20100109202642.GA18657@srcf.ucam.org>
References: <539929391@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539929391@web.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 09, 2010 at 08:14:59PM +0100, Peter Paul wrote:

> Nope, neither with nor without acpi_osi="!Windows 2006", there is nothing in dmesg, no output in acpi_listen and no event in xev.
> I've compared the ACPI messages in dmesg with and without the parameter, the only change is the rather obvious 
> ACPI: Deleted _OSI(Windows 2006)

And /proc/interrupts doesn't change when you hit those keys?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
