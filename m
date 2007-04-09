Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbXDIPg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbXDIPg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 11:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbXDIPg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 11:36:26 -0400
Received: from ozlabs.org ([203.10.76.45]:44299 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515AbXDIPgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 11:36:25 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17946.5545.663353.735623@cargo.ozlabs.ibm.com>
Date: Mon, 9 Apr 2007 20:30:01 +1000
From: Paul Mackerras <paulus@samba.org>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move die notifier handling to common code
In-Reply-To: <20070326065524.GA1163@lst.de>
References: <20070319160218.GA27462@lst.de>
	<17927.8857.752570.69739@cargo.ozlabs.ibm.com>
	<20070326065524.GA1163@lst.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig writes:

> I tend to agree.  Unfortunately powers higher than me like these
> horrible notifier schemes.  Then again at least the die path is not
> performance critical unlike the page faul path where I still need a
> comment for you on getting rid of the notifier.

Sounds reasonable.  If you posted a patch I missed it. :)

Paul.
