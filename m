Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbZJ2Q1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbZJ2Q1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbZJ2Q1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:27:20 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:24246
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753668AbZJ2Q1T convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:27:19 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz4015Lzz1202hzzz2dh2f5h6bh65h)
X-Spam-TCS-SCL: 4:0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: virtual vs physical addresses to cache functions
Date: Thu, 29 Oct 2009 10:26:48 -0600
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: virtual vs physical addresses to cache functions
Thread-Index: AcpYtJ1MkhEv1qRRQ3+7TPrfqzLjwQ==
From: John Linn <John.Linn@xilinx.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 29 Oct 2009 16:27:15.0860 (UTC) FILETIME=[AD50ED40:01CA58B4]
Message-ID: <962b2e4e-74f1-47ea-8847-e16edeef151b@VA3EHSMHS013.ehs.local>
X-Reverse-DNS: unknown-60-83.xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe this is a dumb question...

I believe that the kernel expects virtual addresses to be passed to the
defined cache functions across all architectures.  Looking at PowerPC
and Blackfin confirm this I think.

Can someone confirm this or point to where it's documented as I have dug
for it without finding any specific details?

Thanks,
John

This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


