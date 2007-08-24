Return-Path: <linux-kernel-owner+w=401wt.eu-S1765421AbXHXWts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765421AbXHXWts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 18:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760532AbXHXWtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 18:49:40 -0400
Received: from host-66-43-248-10 ([67.55.143.10]:46926 "EHLO albrecht.rdi1.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758908AbXHXWtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 18:49:40 -0400
X-Greylist: delayed 5527 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Aug 2007 18:49:40 EDT
Subject: coldplug zd1211rw wireless driver results in firefox segfault
From: Paul Albrecht <albrecht@rdi1.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 24 Aug 2007 16:21:42 -0400
Message-Id: <1187986902.24891.12.camel@albrecht.rdi1.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to use a hawking hwu54g with the zd1211rw driver in the
2.6.20 linux kernel. It works ok when I hotplug the device, but causes
firefox to segfault when I coldplug the device.

As I get the segfault whether or not I bring the device up, I'm
wondering if there's a problem with the usb subsystem initialization.

Any ideas? Please cc me because I don't usually subscribe to the lkml.

Paul Albrecht
