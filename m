Return-Path: <linux-kernel-owner+w=401wt.eu-S1763866AbYF0VGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763866AbYF0VGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757814AbYF0VGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:06:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45086 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024AbYF0VGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:06:02 -0400
Subject: Re: [PATCH] Fix a.out.h export to userspace with O= build.
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@kernel.org>, torvalds@linux-foundation.org,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
In-Reply-To: <20080627205712.GA29202@uranus.ravnborg.org>
References: <20080627130236.GD18644@cs181140183.pp.htv.fi>
	 <1214571984.10393.193.camel@pmac.infradead.org>
	 <20080627131231.GF18644@cs181140183.pp.htv.fi>
	 <1214573982.10393.204.camel@pmac.infradead.org>
	 <20080627205712.GA29202@uranus.ravnborg.org>
Content-Type: text/plain
Date: Fri, 27 Jun 2008 22:05:56 +0100
Message-Id: <1214600756.10393.214.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-27 at 22:57 +0200, Sam Ravnborg wrote:
> Hi David.
> 
> Will you carry this patch in your tree or do you
> want me to add it to kbuild-next.git?

I was hoping Linus would apply it, since we could consider it a
regression.

-- 
dwmw2

