Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbXJWNya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbXJWNya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 09:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbXJWNyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 09:54:24 -0400
Received: from tachyon.jukie.net ([205.150.199.214]:49728 "EHLO jukie.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751491AbXJWNyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 09:54:23 -0400
Date: Tue, 23 Oct 2007 09:54:10 -0400
From: Bart Trojanowski <bart@jukie.net>
To: Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org
Cc: kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [BUG] 2.6.23.1 host freezes when running kvm
Message-ID: <20071023135410.GF3962@jukie.net>
References: <20071019202019.GW3962@jukie.net> <20071020000240.GX3962@jukie.net> <20071020154445.GA5254@jukie.net> <471B366B.7040706@qumranet.com> <20071022132820.GA3962@jukie.net> <471CA88B.7000706@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471CA88B.7000706@qumranet.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity <avi@qumranet.com> [071022 09:42]:
> I'm not sure that's useful -- very little changed after 2.6.23-rc1 (10 
> patches).
> 
> There were 92 kvm patches in 2.6.23, so a bisect should take about a 
> week worst case.

I'll get started tonight.

-Bart

-- 
				WebSig: http://www.jukie.net/~bart/sig/
