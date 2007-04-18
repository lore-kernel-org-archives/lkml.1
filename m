Return-Path: <linux-kernel-owner+w=401wt.eu-S1031331AbXDRDi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031331AbXDRDi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 23:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031333AbXDRDi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 23:38:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:18896 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031331AbXDRDi5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 23:38:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,420,1170662400"; 
   d="scan'208"; a="215207735:sNHT18616374"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: drivers/video/output.c
Date: Tue, 17 Apr 2007 23:38:52 -0400
Message-ID: <CFF307C98FEABE47A452B27C06B85BB602F4BDC9@hdsmsx411.amr.corp.intel.com>
In-Reply-To: <20070417213716.GB7284@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: drivers/video/output.c
Thread-Index: AceBOJUQKH9TfZGLRVauupcIwhGphwAMmvzg
From: "Brown, Len" <len.brown@intel.com>
To: "Dave Jones" <davej@redhat.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Cc: "Yu, Luming" <luming.yu@intel.com>, <adaplas@pol.net>, <greg@kroah.com>
X-OriginalArrivalTime: 18 Apr 2007 03:38:55.0957 (UTC) FILETIME=[17873850:01C7816B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>Asides from git-bisect failing me again[1], what gives with this file?

it supports output switching, which didn't make it into 2.6.21 --
probably will be 2.6.22.

-Len
