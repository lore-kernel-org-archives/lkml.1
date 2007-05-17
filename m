Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbXEQPTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbXEQPTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 11:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbXEQPTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 11:19:31 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39207 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757121AbXEQPTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 11:19:30 -0400
Date: Thu, 17 May 2007 16:24:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Claas Langbehn <claas@rootdir.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: This kernel requires the following features not present on the
 CPU... (on a VIA C7 CPU)
Message-ID: <20070517162403.2ff0e3b5@the-village.bc.nu>
In-Reply-To: <464C4A22.7040709@rootdir.de>
References: <464C4A22.7040709@rootdir.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Concerning the crashes I already changed the memory module, but with no 
> success. I'm not sure
> wether this is a hardware or software bug.

Testing with memtest86 should help tell you if the problem is a dodgy
DIMM specifically rather than another hardware or software fault. 
