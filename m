Return-Path: <linux-kernel-owner+w=401wt.eu-S933942AbXF2Qid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933942AbXF2Qid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 12:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760198AbXF2QiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 12:38:24 -0400
Received: from canuck.infradead.org ([209.217.80.40]:37208 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbXF2QiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 12:38:24 -0400
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
From: David Woodhouse <dwmw2@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070629163631.GQ13886@enneenne.com>
References: <20070628084003.GQ13886@enneenne.com>
	 <1183031060.1170.145.camel@pmac.infradead.org>
	 <20070628161450.GD13886@enneenne.com>
	 <1183117082.1170.308.camel@pmac.infradead.org>
	 <20070629150813.GM13886@enneenne.com>
	 <1183130716.1170.347.camel@pmac.infradead.org>
	 <20070629153835.GN13886@enneenne.com>
	 <1183131694.1170.350.camel@pmac.infradead.org>
	 <20070629162346.GO13886@enneenne.com>
	 <1183134208.1170.366.camel@pmac.infradead.org>
	 <20070629163631.GQ13886@enneenne.com>
Content-Type: text/plain
Date: Fri, 29 Jun 2007 17:38:54 +0100
Message-Id: <1183135135.17622.3.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-29 at 18:36 +0200, Rodolfo Giometti wrote:
> On Fri, Jun 29, 2007 at 05:23:28PM +0100, David Woodhouse wrote:
> > 
> > You'll need to put it in an #else case, not in #ifndef __KERNEL__.
> 
> Sorry. :)

That matches what I built with earlier.

-- 
dwmw2

