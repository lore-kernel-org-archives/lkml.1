Return-Path: <linux-kernel-owner+w=401wt.eu-S1756960AbZJ1ARt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbZJ1ARt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 20:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756938AbZJ1ARt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 20:17:49 -0400
Received: from sg2ehsobe005.messaging.microsoft.com ([207.46.51.79]:8264 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756902AbZJ1ARs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 20:17:48 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Oct 2009 20:17:48 EDT
X-SpamScore: 3
X-BigFish: VPS3(zz4015Lzz1202hzzz2dh6bh68o)
X-Spam-TCS-SCL: 7:0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: benchmarking no-mmu and mmu Linux system
Date: Tue, 27 Oct 2009 18:01:38 -0600
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: benchmarking no-mmu and mmu Linux system
Thread-Index: AcpXYdI4PgGFdHshT4evlm3Xj1dmWQ==
From: John Linn <John.Linn@xilinx.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 28 Oct 2009 00:01:39.0229 (UTC) FILETIME=[D2B964D0:01CA5761]
Message-ID: <8381b111-ae73-4ff4-8496-95f0ad7a5930@SG2EHSMHS010.ehs.local>
X-Reverse-DNS: unknown-60-83.xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to figure out a good tool to use to benchmark embedded
systems running Linux (MMU and no-MMU) in a disk-less system.

It would be nice for the tool to support no-MMU without changes.

Lmbench and unixbench are the two I have seen used by others.

Thanks,
John


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


