Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbXITHij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbXITHij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbXITHic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:38:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49212 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbXITHib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:38:31 -0400
Date: Thu, 20 Sep 2007 08:38:18 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jason Wessel <jason.wessel@windriver.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, amitkale@linsyssoft.com,
       trini@kernel.crashing.org
Subject: Re: 2.6.23-rc6-mm1 powerpc - kgdb is broken
Message-ID: <20070920073817.GA28202@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Paul Mackerras <paulus@samba.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Wessel <jason.wessel@windriver.com>,
	Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org, amitkale@linsyssoft.com,
	trini@kernel.crashing.org
References: <46F114D2.40809@linux.vnet.ibm.com> <46F1700D.2020205@windriver.com> <20070919123629.05e3a06c.akpm@linux-foundation.org> <18162.967.558342.829193@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18162.967.558342.829193@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 03:23:19PM +1000, Paul Mackerras wrote:
> I could remove all the kgdb support from arch/powerpc as a first step,
> if that would make it easier to pull in the new stuff...

Given that the existing powerpc kgdb bits didn't seem to work at all when
I tried them that seems like a perfectly fine thing to do.

