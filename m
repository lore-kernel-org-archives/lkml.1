Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbYHHCTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbYHHCTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 22:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbYHHCS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 22:18:57 -0400
Received: from main.gmane.org ([80.91.229.2]:56691 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651AbYHHCS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 22:18:57 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Parag Warudkar <parag.warudkar@gmail.com>
Subject: Re: [ANNOUNCE] mdb-2.6.27-rc2-ia32-08-07-08.patch
Date: Fri, 8 Aug 2008 02:18:39 +0000 (UTC)
Message-ID: <loom.20080808T021730-752@post.gmane.org>
References: <1300.69.2.248.210.1218119365.squirrel@webmail.wolfmountaingroup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 24.208.232.104 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.1) Gecko/2008072820 Firefox/3.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 <jmerkey <at> wolfmountaingroup.com> writes:

> 
> The mdb-rc2 patch was posted this morning with the changes for a modular
> kernel debugger using kprobes.
> 
> ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.27-rc2-ia32-08-07-08.patch

This one fails with build error - send_IPI_mask_bitmask is not exported but used
by mdb.

Parag

