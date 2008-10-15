Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbYJOBwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbYJOBwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 21:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbYJOBw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 21:52:28 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:17950 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbYJOBw2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 21:52:28 -0400
From: "Wildman, Tom" <tom.wildman@hp.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "alan@redhat.com" <alan@redhat.com>
Date: Wed, 15 Oct 2008 01:51:30 +0000
Subject: Superpages Project  -  sourceforge.net/projects/linuxsuperpages
Thread-Topic: Superpages Project  -  sourceforge.net/projects/linuxsuperpages
Thread-Index: Ackt+vJLHAX5TYoOSR+Lk5x7VU2X5wAbMOpA
Message-ID: <F9E7AD49A6823D4AA5A36E1DE32F0F9B27570B8CBC@GVW1092EXB.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A new project has been created at SourceForge with an implementation of the Rice University's Superpages FreeBSD prototype that has been ported to the 2.6 Linux kernel for IA64, x86-64, and x86-32.

The project can be found at:  http://sourceforge.net/projects/linuxsuperpages

The major benefit of supporting Superpages is increased memory reach of the processor's TLB, which reduces the number of TLB misses in applications that have large data sets.  Some benchmarks have been improved 20% in execution time.

Reference www.cs.rice.edu/~jnavarro/superpages/ for more information about the Rice University's Superpages project.

The project is being made available to the Open Source community to share the implementation and knowledge.  With the enhancements to the x86 architectures to support multiple and large page sizes there should be increased interest in this functionality.

/Tom

Tom Wildman
Hewlett-Packard Company
200 Forest Street                    Phone: 978.841.7648
Marlboro, MA  01752                  Email: tom.wildman@hp.com


