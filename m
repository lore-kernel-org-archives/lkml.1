Return-Path: <linux-kernel-owner+w=401wt.eu-S934845AbXGWTsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934845AbXGWTsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932518AbXGWTsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:48:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60312 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765374AbXGWTsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:48:24 -0400
Subject: Re: [PATCH] LinuxPPS - definitive version
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070723122812.3be807ec.akpm@linux-foundation.org>
References: <20070717180550.GA24759@enneenne.com>
	 <1185197716.14697.244.camel@pmac.infradead.org>
	 <20070723122812.3be807ec.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 20:48:19 +0100
Message-Id: <1185220099.14697.265.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 12:28 -0700, Andrew Morton wrote:
> On Mon, 23 Jul 2007 14:35:16 +0100
> David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > Please feed it to scripts/checkpatch.pl -- you can ignore all the
> > warnings about lines greater than 80 characters, and the complete crap
> > about "declaring multiple variables together should be avoided", but
> > some of what it points out is valid.
> 
> The above are David's opinions.  Many, probably most kernel developers do not
> agree with them.

Linus called the 80-column thing a 'Nazi dream' and I'm inclined to
agree with him. It's something to bear in mind, of course, but sometimes
it's best ignored.

And the 'declaring multiple variables together' is something I've
_never_ heard of. Might be applicable if you're actually giving them
initial values, but just declaring them together is fine, surely?

-- 
dwmw2

