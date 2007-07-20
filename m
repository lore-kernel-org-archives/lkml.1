Return-Path: <linux-kernel-owner+w=401wt.eu-S938817AbXGTXlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938817AbXGTXlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 19:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbXGTXlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 19:41:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:13893 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226AbXGTXlo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 19:41:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,564,1175497200"; 
   d="scan'208";a="268773608"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: where is the code for read system call?
Date: Fri, 20 Jul 2007 16:41:42 -0700
Message-ID: <A3258B497F1C1441AD36A2E8B45FD62858CFA6@scsmsx412.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: where is the code for read system call?
thread-index: AcfLJ4abpHD6cnEySeOKSKe3pMog2A==
From: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 20 Jul 2007 23:41:43.0634 (UTC) FILETIME=[873B9320:01C7CB27]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

My application reads from socket. I need to change the behavior of read
system call for an experiment. Can someone point me to code?

thanks
