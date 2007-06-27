Return-Path: <linux-kernel-owner+w=401wt.eu-S1763850AbXF0XJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763850AbXF0XJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 19:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759724AbXF0XJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 19:09:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56841 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758839AbXF0XJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 19:09:08 -0400
Subject: Re: Linux Kernel include files
From: Arjan van de Ven <arjan@infradead.org>
To: 7eggert@gmx.de
Cc: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, bunk@stusta.de,
       schilling@fokus.fraunhofer.de, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1I3g6o-00012P-Hn@be1.lrz>
References: <8AGnE-33a-15@gated-at.bofh.it> <8AISu-6Qn-31@gated-at.bofh.it>
	 <8AISu-6Qn-29@gated-at.bofh.it> <8AKUp-1wx-41@gated-at.bofh.it>
	 <E1I3g6o-00012P-Hn@be1.lrz>
Content-Type: text/plain; charset=UTF-8
Organization: Intel International BV
Date: Wed, 27 Jun 2007 16:07:45 -0700
Message-Id: <1182985665.2800.6.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> @Jörg: The responsibility to maintain clean headers shifted only recently,

yes.. from distro to the kernel ;)

in the old case it was always a distro bug...

> and there is possibly still a lot to do. If you can point out errors, they
> can and probably will be fixed. But as you know, having a precise error
> message or description does help.

absolutely. if you find issues with the "real" kernel headers (eg the
make headers_install ones) ... as you have seen there's lots of interest
to make sure they're as useful as reasonably possible


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

