Return-Path: <linux-kernel-owner+w=401wt.eu-S1759723AbXFQKla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759723AbXFQKla (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 06:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758436AbXFQKlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 06:41:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37925 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757835AbXFQKlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 06:41:23 -0400
Subject: Re: [PATCH] headercheck: add dependency check and improve speed
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20070523181140.GA23425@uranus.ravnborg.org>
References: <20070523181140.GA23425@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sun, 17 Jun 2007 11:41:47 +0100
Message-Id: <1182076908.2799.27.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-23 at 20:11 +0200, Sam Ravnborg wrote:
> David - I assume you will take it in your tree? 

Actually I don't keep a tree for header stuff (except for the automatic
export-to-userspace one at linux/kernel/git/dwmw2/kernel-headers.git
which just tracks Linus' tree.

I figure that keeping headers in shape is a task for _everyone_, which
is sort of why we now have the infrastructure for exporting them and
checking on that.

Could you include it in your kbuild tree, or would you like me to (try
to remember to) send it to Linus myself after 2.6.22 is out?

-- 
dwmw2

