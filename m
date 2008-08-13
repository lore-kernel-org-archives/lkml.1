Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbYHMIm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbYHMIm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755369AbYHMIj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:29 -0400
Received: from smtp.nokia.com ([192.100.105.134]:31871 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304AbYHMIj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:26 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: UBIFS updates for 2.6.27
Date: Wed, 13 Aug 2008 13:17:29 +0300
Message-Id: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
X-OriginalArrivalTime: 13 Aug 2008 08:39:02.0878 (UTC) FILETIME=[0A028FE0:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Christoph asked me to send UBIFS patches here before I put them
to Linux next.

The following are patches we plan to send to Linus before 2.6.27
is out. Some of the patches are not fixes, but because UBIFS is
new and 2.6.27 will be its first release, we think it is OK to
merge "non-fix" patches for UBIFS as an exception.

Christoph, I do not send NFS patch for now because I'd like to
work on it some more, taking into account your suggestions.
