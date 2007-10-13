Return-Path: <linux-kernel-owner+w=401wt.eu-S1761467AbXJMJo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467AbXJMJo5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 05:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbXJMJou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 05:44:50 -0400
Received: from www.tglx.de ([62.245.132.106]:57047 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122AbXJMJot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 05:44:49 -0400
Date: Sat, 13 Oct 2007 11:44:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Mike Galbraith <efault@gmx.de>, Giacomo Catenazzi <cate@debian.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23.git build error
In-Reply-To: <20071013081759.GB28168@uranus.ravnborg.org>
Message-ID: <alpine.LFD.0.9999.0710131143520.3918@localhost.localdomain>
References: <1192164538.10413.3.camel@Homer.simpson.net> <20071012213114.GA24016@uranus.ravnborg.org> <1192246457.7395.19.camel@Homer.simpson.net> <47105A39.9070406@debian.org> <20071013071626.GA28168@uranus.ravnborg.org> <1192260909.7369.20.camel@Homer.simpson.net>
 <20071013081759.GB28168@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Oct 2007, Sam Ravnborg wrote:
> But I cannot see how this could result in the bug you
> reported..
> Anyway at least one dontdiff buglet - or we should preferably
> drop the .i files in the kernel src.

I have a patch from Adrian staged to do this.

       tglx
