Return-Path: <linux-kernel-owner+w=401wt.eu-S1763483AbXGWW7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763483AbXGWW7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 18:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbXGWW7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 18:59:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:30868 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbXGWW7a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 18:59:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,572,1175497200"; 
   d="scan'208";a="271774493"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: named pipe handling
Date: Mon, 23 Jul 2007 15:59:28 -0700
Message-ID: <A3258B497F1C1441AD36A2E8B45FD62858D850@scsmsx412.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: named pipe handling
thread-index: AcfNfQb9/bv0JFPzRQm84wAaBBc5Ug==
From: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 23 Jul 2007 22:59:29.0710 (UTC) FILETIME=[2022B4E0:01C7CD7D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Can someone point me to named pipe read/write functions (when I issue
read system call on a file handle obtained from mkfifo call which
function ultimately handles it)?
