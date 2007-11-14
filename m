Return-Path: <linux-kernel-owner+w=401wt.eu-S1759325AbXKNOmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325AbXKNOmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755896AbXKNOmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:42:40 -0500
Received: from palrel10.hp.com ([156.153.255.245]:39147 "EHLO palrel10.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363AbXKNOmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:42:39 -0500
Date: Wed, 14 Nov 2007 07:42:37 -0700
From: Alex Chiang <achiang@hp.com>
To: Gary Hade <garyhade@us.ibm.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071114144237.GB7523@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
	Greg KH <greg@kroah.com>, gregkh@suse.de,
	kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
	linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
	pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <20071113183353.GE17785@parisc-linux.org> <20071113185122.GA22536@kroah.com> <20071113201102.GK17785@parisc-linux.org> <20071113230804.GA14570@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113230804.GA14570@us.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gary,

* Gary Hade <garyhade@us.ibm.com>:
> 
> I am not fundamentally opposed to this new capability but share
> the same concerns that Greg and others have expressed.  So far,
> I have only tried the changes on one single node system (IBM
> x3850) but the below NAK-worthy result supports the idea that
> the changes need to be well and widely tested.

Can you send me the lspci -vv and lspci -vt output from this
machine?

Thanks.

/ac

