Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbXJZURL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbXJZURL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbXJZUQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:16:58 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:59239 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbXJZUQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:16:57 -0400
Date: Fri, 26 Oct 2007 22:18:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 0/6] kernel-doc: add DOC: sections support
Message-ID: <20071026201832.GA24160@uranus.ravnborg.org>
References: <11932637282902@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11932637282902@xenotime.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 03:08:48PM -0700, Randy Dunlap wrote:
> 
> This patch series from Johannes Berg adds support for DOC: sections
> that are embedded in source files.

Thanks - added to kbuild.git after a few small fix-ups.
[Whitespace + the last bit did not apply].

	Sam
