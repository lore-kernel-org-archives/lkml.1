Return-Path: <linux-kernel-owner+w=401wt.eu-S1752910AbYIHIxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbYIHIxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 04:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750887AbYIHIxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 04:53:00 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:4737 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbYIHIw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 04:52:59 -0400
Date: Mon, 8 Sep 2008 11:52:39 +0300
From: Martin Michlmayr <tbm@cyrius.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Brice Goglin <brice@myri.com>, Lennert Buytenhek <buytenh@marvell.com>
Subject: Re: [Bug #11334] myri10ge: use ioremap_wc: compilation failure on
	ARM
Message-ID: <20080908085239.GF14935@deprecation.cyrius.com>
References: <s3QDdfEDq6.A.wlH.MowwIB@albercik> <Wz8EH5sroeE.A.aLC.aqwwIB@albercik> <20080907155952.GA24110@xi.wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080907155952.GA24110@xi.wantstofly.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lennert Buytenhek <buytenh@wantstofly.org> [2008-09-07 17:59]:
> Still relevant.  A patch to fix this has been submitted and should be in
> the ARM tree, but it has not made its way upstream yet, and the original
> submitter has not confirmed that it fixes the problem yet.

Your patch fixes the compilation error I reported, thanks.
-- 
Martin Michlmayr
http://www.cyrius.com/
