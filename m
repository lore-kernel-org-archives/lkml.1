Return-Path: <linux-kernel-owner+w=401wt.eu-S1752043AbXCYKXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbXCYKXG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 06:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbXCYKXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 06:23:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54415 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbXCYKXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 06:23:05 -0400
Subject: Re: [patch] rfc: introduce /dev/hugetlb
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ken Chen <kenchen@google.com>, Adam Litke <agl@us.ibm.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070323205810.3860886d.akpm@linux-foundation.org>
References: <b040c32a0703230144r635d7902g2c36ecd7f412be31@mail.gmail.com>
	 <20070323205810.3860886d.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 25 Mar 2007 12:22:29 +0200
Message-Id: <1174818149.1158.301.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> But libraries are hard, for a number of distributional reasons.  

I don't see why this is the case to be honest.
You can ask distros to ship your library, and if it's a sensible one,
they will. And if you can't wait, you can always bundle the library with
your application, it's really not a big deal to do that properly.

That's not a reason to make it a harder problem by tying a library to
the kernel source... in fact I know enterprise distros are more likely
to uprev a library than to uprev a kernel.... tying them together you
get the worst of both worlds....

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

