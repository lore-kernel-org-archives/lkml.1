Return-Path: <linux-kernel-owner+w=401wt.eu-S1760568AbXJaWG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760568AbXJaWG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761573AbXJaWFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:05:48 -0400
Received: from helios.cs.csubak.edu ([136.168.201.112]:55115 "EHLO
	helios.cs.csubak.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761568AbXJaWFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:05:47 -0400
X-Greylist: delayed 2108 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Oct 2007 18:05:47 EDT
Date: Wed, 31 Oct 2007 14:30:37 -0700 (PDT)
From: David Griffith <dgriffi@cs.csubak.edu>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: fixing usb-midi device support
Message-ID: <Pine.GSO.4.55.0710311423530.10148@helios.cs.csubak.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -0.1 (/)
X-Spam-Report: ---- Start Spam Filter Report
	Filter Analysis score is (-0.1/5.0)
	-0.0 NO_RELAYS              Informational: message was not relayed via SMTP
	-0.1 AWL                    AWL: From: address is in the auto white-list
	---- End Spam Filter results
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I have a MOTU Fastlane and an Emu Xmidi 2x2 USB midi interfaces.  The Emu
unit works fine with current kernels.  The MOTU unit won't work with
kernels newer than 2.6.17.  I stumbled over a patch that had something to
do with a MOTU Fastlane, but I haven't been able to find it again.  Could
I get some advice on fixing MOTU Fastlane support?


-- 
David Griffith
dgriffi@cs.csubak.edu
