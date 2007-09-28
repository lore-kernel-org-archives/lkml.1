Return-Path: <linux-kernel-owner+w=401wt.eu-S1756950AbXI1SWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbXI1SWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbXI1SW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:22:28 -0400
Received: from mail.trixing.net ([87.230.125.58]:56493 "EHLO mail.trixing.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbXI1SW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:22:28 -0400
Message-ID: <46FD4650.60009@l4x.org>
Date: Fri, 28 Sep 2007 20:22:08 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070329 Thunderbird/1.5.0.10 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Ken Schmidt <kenneth.schmidt@pnl.gov>
CC: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
References: <20070928101601.0ccc1b74.kenneth.schmidt@pnl.gov>
In-Reply-To: <20070928101601.0ccc1b74.kenneth.schmidt@pnl.gov>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.195
X-SA-Exim-Mail-From: jdi@l4x.org
Subject: Re: [patch 01/02] vfs: variant symlinks
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:51:29 +0000)
X-SA-Exim-Scanned: Yes (on mail.trixing.net)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ken Schmidt wrote:
> Variant symlinks add the ability to embed variables in to the
> contents of symbolic links so their targets can change based on
> outside sources (user environment, uts, filesystems, etc.)

Could you elaborate why this is needed and what part cannot
be solved in userspace (linkfarm on tmpfs or intelligent
scripts)?

Thanks,

Jan
