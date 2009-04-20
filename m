Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbZDTFOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbZDTFOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 01:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbZDTFOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 01:14:07 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:40925 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbZDTFOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 01:14:06 -0400
Date: Mon, 20 Apr 2009 01:13:51 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Thomas Renninger <trenn@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, cpufreq@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2] acpi: Fix regression where _PPC is not read at boot
 even when ignore_ppc=0
In-reply-to: <20090416224507.GA31984@srcf.ucam.org>
Message-id: <alpine.LFD.2.00.0904200112290.10996@localhost.localdomain>
References: <20090415225348.GW8311@plum> <20090416002712.GX8311@plum>
 <200904161201.13409.trenn@suse.de> <20090416174217.GY8311@plum>
 <20090416224507.GA31984@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI,
Thanks to Ebay, I now have a T60:-)

and so i put the DSDT here:
http://bugzilla.kernel.org/show_bug.cgi?id=13139

I'll poke at this in more detail soon...

thanks,
Len Brown, Intel Open Source Technology Center

