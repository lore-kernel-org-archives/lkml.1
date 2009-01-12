Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbZALTa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbZALTa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 14:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbZALTaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 14:30:46 -0500
Received: from websrv.werbeagentur-aufwind.de ([88.198.253.206]:42972 "EHLO
	websrv.werbeagentur-aufwind.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753472AbZALTap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 14:30:45 -0500
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jan 2009 14:30:44 EST
Subject: Re: [PATCH]: xen: fix too early kmalloc call
From: Christophe Saout <christophe@saout.de>
To: Mike Travis <travis@sgi.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <496B8A79.4060309@sgi.com>
References: <496A4C8F.8070005@sgi.com> <20090112085302.GB21976@elte.hu>
	 <20090112144218.GA18859@cmpxchg.org>  <496B8A79.4060309@sgi.com>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 20:23:23 +0100
Message-Id: <1231788203.4901.7.camel@leto.intern.saout.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

> Yes, that's picked up in a subsequent patch (I didn't catch it the
> first time I reviewed it as well.)  There appears to be a queue of
> patches for Xen coming, so this last "memory reduction patch" will
> follow (or be included with) those.

It appears Jeremy is on vacation and I also don't know which of the
patches are meant for upstream (there seem still to be some bugs that
might need fixing), and it doesn't really matter if the XEN patches are
updated to your patch or the other way around.  The patches in the XEN
mercurial tree already do not apply the way they were before Jeremy went
on vacation, so in my opinion you can as well just go ahead.

Cheers,
	Christophe


