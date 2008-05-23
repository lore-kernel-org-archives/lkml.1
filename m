Return-Path: <linux-kernel-owner+w=401wt.eu-S1760725AbYEWX65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760725AbYEWX65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 19:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756275AbYEWX6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 19:58:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53901 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbYEWX6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 19:58:48 -0400
Subject: Re: crossbuild fails in modpost
From: David Woodhouse <dwmw2@infradead.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Adrian Bunk <bunk@kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Michael Buesch <mb@bu3sch.de>,
       Gordon Farquharson <gordonfarquharson@gmail.com>
In-Reply-To: <alpine.LNX.1.10.0805182314450.15590@fbirervta.pbzchgretzou.qr>
References: <482C3E3E.9090204@gmail.com> <482C6F02.1000205@gmail.com>
	 <20080515173539.GA23959@uranus.ravnborg.org>
	 <20080515174015.GA24024@uranus.ravnborg.org> <482C8CBE.2060101@gmail.com>
	 <20080515204632.GG1936@cs181133002.pp.htv.fi>
	 <alpine.LNX.1.10.0805182155011.15590@fbirervta.pbzchgretzou.qr>
	 <20080518204258.GL8140@cs181133002.pp.htv.fi>
	 <alpine.LNX.1.10.0805182314450.15590@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Sat, 24 May 2008 00:58:46 +0100
Message-Id: <1211587126.31212.50.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-05-18 at 23:15 +0200, Jan Engelhardt wrote:
> Of course not. Ever since the arch unification, building for the
> other bitness in bi- or multiarch systems has become harder.

It works fine for the unified powerpc tree.

-- 
dwmw2

