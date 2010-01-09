Return-Path: <linux-kernel-owner+w=401wt.eu-S1752419Ab0AIXiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab0AIXiK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 18:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667Ab0AIXiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 18:38:09 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:47617 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab0AIXiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 18:38:06 -0500
Date: Sat, 9 Jan 2010 23:38:02 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Peter Paul <abnominales@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ACPI quirks - acpi_osi="!Windows 2006" required on FSC Amilo
	notebooks to enable brightness keys
Message-ID: <20100109233802.GA20615@srcf.ucam.org>
References: <539929391@web.de> <20100109202642.GA18657@srcf.ucam.org> <1263073701.6497.75.camel@rechenknecht2k7> <20100109220606.GA19441@srcf.ucam.org> <1263076707.1675.6.camel@virtubuntu> <20100109231122.GA19789@srcf.ucam.org> <1263079195.20284.2.camel@virtubuntu> <20100109232324.GA20504@srcf.ucam.org> <1263079816.20284.3.camel@virtubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263079816.20284.3.camel@virtubuntu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, 

grep -r . /proc/acpi/video

-- 
Matthew Garrett | mjg59@srcf.ucam.org
