Return-Path: <linux-kernel-owner+w=401wt.eu-S1752211AbXDGL3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbXDGL3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 07:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbXDGL3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 07:29:21 -0400
Received: from [212.12.190.169] ([212.12.190.169]:34115 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752211AbXDGL3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 07:29:21 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-fsdevel@vger.kernel.org
Subject: compressing intermediate files with LZO on the fly
Date: Sat, 7 Apr 2007 14:32:34 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704071432.34157.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
>
> ... for some usages (temporary space),
> light compression can increase speed. For instance, when processing logs,
> I get better speed by compressing intermediate files with LZO on the fly.

How can you do that on ext3?

Also, can you do that on a partition block-io level?


Thanks!

--
Al

