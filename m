Return-Path: <linux-kernel-owner+w=401wt.eu-S1752718AbXCMSNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbXCMSNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 14:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbXCMSNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 14:13:40 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41953 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752718AbXCMSNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 14:13:39 -0400
Date: Tue, 13 Mar 2007 19:09:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Hansen <hansendc@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>, containers@lists.osdl.org,
       menage@google.com, linux-kernel@vger.kernel.org, xemul@sw.ru
Subject: Re: [RFC][PATCH 2/7] RSS controller core
Message-ID: <20070313190931.1417c012@lxorguk.ukuu.org.uk>
In-Reply-To: <1173806793.6680.44.camel@localhost.localdomain>
References: <45ED7DEC.7010403@sw.ru>
	<45ED80E1.7030406@sw.ru>
	<20070306140036.4e85bd2f.akpm@linux-foundation.org>
	<45F3F581.9030503@sw.ru>
	<20070311045111.62d3e9f9.akpm@linux-foundation.org>
	<20070312010039.GC21861@MAIL.13thfloor.at>
	<1173724979.11945.103.camel@localhost.localdomain>
	<20070312224129.GC21258@MAIL.13thfloor.at>
	<20070312220439.677b4787.akpm@linux-foundation.org>
	<1173806793.6680.44.camel@localhost.localdomain>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> stuff is happening by comparing page->count and page->_mapcount, but it
> certainly wouldn't be conclusive.  But, does this kind of nonsense even
> happen in practice?  

"Is it useful for me as a bad guy to make it happen ?"

Alan
