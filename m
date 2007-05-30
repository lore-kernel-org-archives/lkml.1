Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbXE3X5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbXE3X5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbXE3X4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:56:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:58159 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbXE3X4u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:56:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,595,1170662400"; 
   d="scan'208";a="233851919"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: BUG: sleeping function called from invalid context at kernel/fork.c:385
Date: Wed, 30 May 2007 16:56:47 -0700
Message-ID: <79E93560F4A5FD42BB769DAAF8BEF62A01B633E9@scsmsx411.amr.corp.intel.com>
In-Reply-To: <f1318b470705301650y5ed9fdbn12ad0ebe30233336@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: BUG: sleeping function called from invalid context at kernel/fork.c:385
Thread-Index: AcejFV7TOe/cioVORNWDJLUOa+QbfQAAA6lQ
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, "David Chinner" <dgc@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "lkml" <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
       "Sam Ravnborg" <sam@ravnborg.org>,
       "Christoph Lameter" <clameter@sgi.com>
X-OriginalArrivalTime: 30 May 2007 23:56:48.0963 (UTC) FILETIME=[2FC89130:01C7A316]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Saw this when running strace -f on a script on 2.6.21 on ia64
Run strace -f on 2.6.22-rc3 on Tiger4/Montecito. Couldn't reproduce
this issue. Kernel was built with both defconfig and tiger_defconfig.

Thanks.

-Fenghua
