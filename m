Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbYJXNmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbYJXNmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 09:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbYJXNmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 09:42:16 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:58485 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbYJXNmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 09:42:14 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4901D0C1.9090004@gmail.com>
Date: Fri, 24 Oct 2008 14:42:25 +0100
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, eric miao <eric.y.miao@gmail.com>,
       Mike Rapoport <mike@compulab.co.il>
Subject: MFD missing Kconfig and Makefile entries for da903x
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

I'm either missing something or despite the da903x driver being
merged it doesn't have suitable entries in the drivers/mfd/Kconfig
etc.

I'm guessing something went wrong merging the original patches
of Eric and Mike?

Thanks,

Jonathan
