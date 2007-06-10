Return-Path: <linux-kernel-owner+w=401wt.eu-S1757689AbXFJCcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689AbXFJCcR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 22:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbXFJCcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 22:32:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48830 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbXFJCcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 22:32:07 -0400
Date: Sun, 10 Jun 2007 03:31:39 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Sam Ravnborg <sam@ravnborg.org>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <rdunlap@xenotime.net>,
       LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Chen Li-jun <cljun@xiyou.edu.cn>, Wang Ya-gang <lazy_linux@126.com>
Subject: Re: [RFC] Documentation/CodingStyle: Add rules for goto labels (-v2)
Message-ID: <20070610023139.GA21478@ftp.linux.org.uk>
References: <20070603142450.GA4230@localhost.localdomain> <20070603142939.GW4095@ftp.linux.org.uk> <20070603074552.430c3d02.rdunlap@xenotime.net> <4662DFCF.3010606@garzik.org> <20070604045857.GE2161@localhost.localdomain> <4663B84E.2060103@goop.org> <20070604081938.GC2074@localhost.localdomain> <20070604183014.GB16187@uranus.ravnborg.org> <466461C4.2050806@goop.org> <20070605013735.GA2388@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605013735.GA2388@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 09:37:36AM +0800, WANG Cong wrote:
> I agree. Local labels maybe useful in macros.
> If someone will use local labels in his code some day, we shouldn't force him
> to align his labels in the first column.
 
No, we should just force him to rewrite his dreck into a readable form
and get rid of that junk...
