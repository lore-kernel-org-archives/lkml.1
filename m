Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbXJZT6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbXJZT6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbXJZT6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:58:10 -0400
Received: from khc.piap.pl ([195.187.100.11]:49799 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbXJZT6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:58:09 -0400
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, sylvain.meyer@worldonline.fr,
       linux-kernel@vger.kernel.org, "Antonino A. Daplas" <adaplas@pol.net>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] Intel FB pixel clock calculation fix
References: <m3ir6il3wl.fsf@maximus.localdomain>
	<20070910225221.f0eaf22c.akpm@linux-foundation.org>
	<m3veah75u6.fsf@maximus.localdomain>
	<20071026175143.GB1573@elf.ucw.cz>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 26 Oct 2007 21:58:05 +0200
In-Reply-To: <20071026175143.GB1573@elf.ucw.cz> (Pavel Machek's message of "Fri, 26 Oct 2007 19:51:43 +0200")
Message-ID: <m33avxlkc2.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> On Tue 2007-09-11 14:18:57, Krzysztof Halasa wrote:
>> I think 2.6.22 would be overkill, .23 - not sure.
>
> I don't think this is -stable kind of bug.

Given the timeframe, I can only agree once again :-)
-- 
Krzysztof Halasa
