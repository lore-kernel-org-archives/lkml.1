Return-Path: <linux-kernel-owner+w=401wt.eu-S1761657AbXKBRTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761657AbXKBRTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757141AbXKBRTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:19:45 -0400
Received: from tachyon.jukie.net ([205.150.199.214]:35046 "EHLO jukie.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757176AbXKBRTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:19:44 -0400
Date: Fri, 2 Nov 2007 13:19:33 -0400
From: Bart Trojanowski <bart@jukie.net>
To: Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org
Cc: kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [BUG] 2.6.23.1 host freezes when running kvm
Message-ID: <20071102171933.GE32719@jukie.net>
References: <20071019202019.GW3962@jukie.net> <20071020000240.GX3962@jukie.net> <20071020154445.GA5254@jukie.net> <471B366B.7040706@qumranet.com> <20071022132820.GA3962@jukie.net> <471CA88B.7000706@qumranet.com> <20071023135410.GF3962@jukie.net> <471E033E.20701@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471E033E.20701@qumranet.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity <avi@qumranet.com> [071023 10:21]:
> Thanks, that will be most helpful.  If userspace won't compile against
> some intermediate version, let me know the commit hash and I'll add a fixup.

A bisect didn't find anything between 2.6.22 and 2.6.23.  Which made me
very confused.  I think, I must have used the Debian userland tools...
which is still bad and I will double check that with 2.6.23.

-Bart

