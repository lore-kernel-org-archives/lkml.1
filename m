Return-Path: <linux-kernel-owner+w=401wt.eu-S1764076AbXF2LiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764076AbXF2LiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 07:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757658AbXF2LiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 07:38:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38126 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758138AbXF2LiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 07:38:05 -0400
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
From: David Woodhouse <dwmw2@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070628161450.GD13886@enneenne.com>
References: <20070627125802.GI13886@enneenne.com>
	 <1182960660.1170.12.camel@pmac.infradead.org>
	 <20070627174537.GM13886@enneenne.com>
	 <1182966588.1170.28.camel@pmac.infradead.org>
	 <20070627224623.GO13886@enneenne.com>
	 <1183018133.1170.46.camel@pmac.infradead.org>
	 <20070628081538.GP13886@enneenne.com>
	 <1183019474.1170.66.camel@pmac.infradead.org>
	 <20070628084003.GQ13886@enneenne.com>
	 <1183031060.1170.145.camel@pmac.infradead.org>
	 <20070628161450.GD13886@enneenne.com>
Content-Type: text/plain
Date: Fri, 29 Jun 2007 12:38:02 +0100
Message-Id: <1183117082.1170.308.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-28 at 18:14 +0200, Rodolfo Giometti wrote:
> here my new LinuxPPS patch.
> 
> What to do now for kernel inclusion? Should I provide several patches?
> If so how should I divide them? 

It doesn't apply to the current git tree, which has already had some new
system calls added.

-- 
dwmw2

