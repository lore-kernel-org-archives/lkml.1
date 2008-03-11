Return-Path: <linux-kernel-owner+w=401wt.eu-S1756982AbYCKGnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbYCKGnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 02:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbYCKGnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 02:43:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48110 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbYCKGnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 02:43:31 -0400
Subject: Re: [PATCH] kvm: provide kvm.h for all architecture: fixes
	headers_install
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Avi Kivity <avi@qumranet.com>, Sam Ravnborg <sam@ravnborg.org>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>,
       linux-arch@vger.kernel.org, mm-commits@vger.kernel.org
In-Reply-To: <20080310232039.d2a34f5a.akpm@linux-foundation.org>
References: <200803071326.06682.borntraeger@de.ibm.com>
	 <1204933418.2495.14.camel@shinybook.infradead.org>
	 <200803101411.04175.borntraeger@de.ibm.com>
	 <20080310232039.d2a34f5a.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 11 Mar 2008 07:42:25 +0100
Message-Id: <1205217745.2592.86.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-10 at 23:20 -0700, Andrew Morton wrote:
> 
> > Changes since v1:
> > o use asm-generic/Kbuild.asm (Arnd Bergmann)

I don't see that in the diffstat of the patch you dropped (looking at
the immediately subsequent mail in my inbox). Which might explain...

> /usr/src/devel/usr/include/linux/kvm.h requires asm/kvm.h, which does
> not exist in exported headers

-- 
dwmw2

