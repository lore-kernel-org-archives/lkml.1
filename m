Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbXESB71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbXESB71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 21:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbXESB7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 21:59:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37546 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbXESB7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 21:59:19 -0400
Subject: Re: [PATCH] ubi: kill homegrown endian macros
From: David Woodhouse <dwmw2@infradead.org>
To: matthieu castet <castet.matthieu@free.fr>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <464E049C.9050006@free.fr>
References: <20070517143200.GA30850@lst.de>
	 <1179413443.3642.49.camel@sauron> <20070517145653.GA968@lst.de>
	 <1179414590.3642.69.camel@sauron>
	 <20070517102931.6bbbad1a.akpm@linux-foundation.org>
	 <pan.2007.05.17.20.30.30@free.fr>
	 <1179455959.2859.527.camel@shinybook.infradead.org>
	 <464E049C.9050006@free.fr>
Content-Type: text/plain
Date: Sat, 19 May 2007 09:29:21 +0800
Message-Id: <1179538161.2859.619.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-18 at 21:55 +0200, matthieu castet wrote:
> > Are you suggesting that this has changed since I did my testing?
> > 
> Which version of gcc did you try ?

It was a while ago -- probably 3.2 or something like that. I think it
might even predate the summary support.

When I get home I'll take another look. 

-- 
dwmw2

