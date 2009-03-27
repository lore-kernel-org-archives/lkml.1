Return-Path: <linux-kernel-owner+w=401wt.eu-S1758391AbZC0QH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391AbZC0QH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 12:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbZC0QHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 12:07:09 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:39562 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbZC0QHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 12:07:06 -0400
Date: Fri, 27 Mar 2009 12:06:44 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Dan Williams <dcbw@redhat.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org, linux-hotplug@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Network Device Naming mechanism and policy
In-reply-to: <1238098611.3254.8.camel@localhost.localdomain>
Message-id: <alpine.LFD.2.00.0903271203140.26419@localhost.localdomain>
References: <20090324154617.GA16332@auslistsprd01.us.dell.com>
 <20090324.155756.214460004.davem@davemloft.net>
 <20090326163955.GA22398@auslistsprd01.us.dell.com>
 <1238098611.3254.8.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > So, please, put mapping tables into the ACPI or similar

ACPI added _PLD (Physical Device Location) back in 3.0, ISTR.
However, searching my archives, I have yet to see a single instance
of its use in the field.

ACPI also supplies the slot number stuff, which is exported via 
the existing pci_slot driver.

cheers,
Len Brown, Intel Open Source Technology Center
