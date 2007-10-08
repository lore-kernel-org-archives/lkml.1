Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbXJHV0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbXJHV0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 17:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbXJHV0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 17:26:13 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:56198 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbXJHV0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 17:26:12 -0400
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Oct 2007 17:26:12 EDT
Message-ID: <470A9F2E.2090104@cateee.net>
Date: Mon, 08 Oct 2007 23:20:46 +0200
From: Giacomo Catenazzi <cate@cateee.net>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Sam Ravnborg <sam@ravnborg.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT] kbuild: save ARCH & CROSS_COMPILE
References: <20071008200255.GA16497@uranus.ravnborg.org> <20071008211255.GP16424@stusta.de>
In-Reply-To: <20071008211255.GP16424@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> 
> BTW: I'm currently trying without success to understand why the
>      drivers/infiniband/{hw/amso1100,ulp/srp}/Kbuild files are not
>      named "Makefile".

or the inverse ;-)  Why all Makefiles (but the top level one ) are not
named Kbuild, considering that they are not valid (standalone) Makefile.

ciao
	cate
