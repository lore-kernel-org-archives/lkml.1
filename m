Return-Path: <linux-kernel-owner+w=401wt.eu-S934588AbXGTWB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934588AbXGTWB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758333AbXGTWBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:01:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:45393 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756765AbXGTWBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:01:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,564,1175497200"; 
   d="scan'208";a="108352727"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 5/7] I/OAT: Add support for MSI and MSI-X
Date: Fri, 20 Jul 2007 15:00:56 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C02B81B55@orsmsx418.amr.corp.intel.com>
In-Reply-To: <1a297b360707201459s57fb4778m2be80e4c2b825b2c@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 5/7] I/OAT: Add support for MSI and MSI-X
Thread-Index: AcfLGS7GzA5T31TFSceAPFGi/hP9EwAAB87w
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Manu Abraham" <abraham.manu@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 20 Jul 2007 22:00:56.0748 (UTC) FILETIME=[7301FEC0:01C7CB19]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Manu Abraham [mailto:abraham.manu@gmail.com] 
>
>Ok. Thanks for clearing it up. So the idea would be that if
>pci_enable_msix() for "n" number of messages failed, then settle down
>for 1 message, which is equivalent to MSI mode
>

yep
