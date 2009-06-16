Return-Path: <linux-kernel-owner+w=401wt.eu-S1758880AbZFPQl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880AbZFPQl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbZFPQlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:41:20 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:50120 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbZFPQlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:41:19 -0400
Message-ID: <4A37CB2A.6010209@davidnewall.com>
Date: Wed, 17 Jun 2009 02:11:14 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Ralf Gross <rg@stz-softwaretechnik.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: io-scheduler tuning for better read/write ratio
References: <20090616154342.GA7043@p15145560.pureserver.info>
In-Reply-To: <20090616154342.GA7043@p15145560.pureserver.info>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Gross wrote:
> write throughput is much higher than the read throughput (40 MB/s
> read, 90 MB/s write).

Perhaps I've misunderstood, but isn't that common?  Reads have to come
from disk, whereas writes get cached by the drive.
