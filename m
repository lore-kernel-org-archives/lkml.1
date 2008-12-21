Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbYLUMOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbYLUMOJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 07:14:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYLUMN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 07:13:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:48072 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbYLUMNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 07:13:55 -0500
Subject: Re: [PATCH] firmware: Arrange WHENCE in alphabetical order to
 avoid conflicts
From: David Woodhouse <dwmw2@infradead.org>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1229860427.6846.3.camel@jaswinder.satnam>
References: <1229860427.6846.3.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Sun, 21 Dec 2008 12:12:59 +0000
Message-Id: <1229861579.22786.32.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-12-21 at 17:23 +0530, Jaswinder Singh wrote:
> 
> We are facing problems while we prepare patch for firmware as we add
> new stuff at the end.
> As per David Woodhouse suggestion, I am arranging WHENCE to
> aplhabetical order by driver name to avoid conflicts.
> Thanks to my son Gurchet Singh to help me in arranging driver names in
> alphabetical order.
> 
> Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>

Acked-by: David Woodhouse <David.Woodhouse@intel.com>

Now we're trying to push the remaining conversions to request_firmware()
via the driver authors, putting it into alphabetical order should help
to avoid the conflicts.

If we could have this in before 2.6.28 (since it's purely cosmetic) or
immediately thereafter, that would be great.

Thanks, Jaswinder.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

