Return-Path: <linux-kernel-owner+w=401wt.eu-S1161464AbXDLCjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161464AbXDLCjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161483AbXDLCjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:39:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:32090 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161464AbXDLCjR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:39:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,399,1170662400"; 
   d="scan'208"; a="212065073:sNHT63313222"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Announce: New release of Linux-ready Firmware Dev Kit - Release 2
Date: Wed, 11 Apr 2007 19:39:11 -0700
Message-ID: <F8A0EBD0F30CA24B974BD57423860EAE02F939EF@orsmsx415.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Announce: New release of Linux-ready Firmware Dev Kit - Release 2
Thread-Index: Acd8q8B/0KE6obGjS/Kno/oy6IITEA==
From: "Selbak, Rolla N" <rolla.n.selbak@intel.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Apr 2007 02:39:12.0239 (UTC) FILETIME=[C0FCBFF0:01C77CAB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The Linux-ready Firmware Developer Kit team is pleased to announce the
release R2 of the kit. 

This release is mostly very heavy with bug-fixes,
infrastructure re-org. to make it easier for outside developers to 
write & contribute plugins, and of course, tons of documentation. A few
new tests and features have been added, including things you've asked
for
such as ssh-upload and a text-based version of the results.

The Linux-ready Firmware Developer Kit is a tool to test how well Linux
works together with the firmware (BIOS or EFI) of your machine, and is
designed for use by both firmware development teams and Linux kernel
hackers to prevent and diagnose firmware bugs.

Summary
=======

Enhancements
* ssh upload of results
* globalized DSDT & SSDT lists for standalone and .so plugins
* better logically implemented dmesg and e820 functions
* text-based results
* documentation of each plugin and the meaning if its results 
	(Documentation/TestsInfo)
* bug-fixes


New Tests
=========
* ia64 error injection tool
* fan test (now functional)
* SUN test (now functional)
* ebda test
* cpufreq: added test for Ingo's _PSS bug
* dmesg: added detection for buzilla.kernel.org bug 6859


You can download this latest release of the kit from

    http://www.linuxfirmwarekit.org


The Linux-ready Firmware Developer Kit team
	Jacob Pan
	Rolla Selbak
	Arjan van de Ven


[Please cc my email on any replies or comments]

Thanks,

rs

