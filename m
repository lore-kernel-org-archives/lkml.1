Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbXFSMMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbXFSMMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 08:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756319AbXFSMMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 08:12:30 -0400
Received: from savages.net ([66.93.39.24]:37039 "EHLO mail.savages.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756244AbXFSMM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 08:12:29 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jun 2007 08:12:29 EDT
Message-ID: <4677C702.6050102@savages.net>
Date: Tue, 19 Jun 2007 05:07:30 -0700
From: Shaun Savage <savages@savages.net>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: How do you allocate huge pages.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am trying to allocate very large memory within the kernel. I want to
start by allocating one huge (4M) page and using that as buffer space.

How do you do this?

shaun
