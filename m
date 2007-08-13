Return-Path: <linux-kernel-owner+w=401wt.eu-S1033150AbXHMS2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033150AbXHMS2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S973290AbXHMSHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:07:39 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2585 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765059AbXHMSHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:07:35 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch - scripts/get_maintainer.pl
Date: Mon, 13 Aug 2007 20:07:32 +0200
User-Agent: KMail/1.9.5
Cc: Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
References: <1186984174.10249.7.camel@localhost> <200708131933.10125.m.kozlowski@tuxland.pl> <1187026955.2688.4.camel@laptopd505.fenrus.org>
In-Reply-To: <1187026955.2688.4.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708132007.32334.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 	I don't recall discusion about this so here are my 3 cents:
> > 
> > 	I like the idea. 
> 
> I don't actually. It shows a central MAINTAINERS file is the wrong
> approach; just that 500+ patches to the same file were needed shows
> that. 
> 
> The maintainer info should be in the source file itself! That's the only
> reasonable way to keep it updated; now I'm all for having it machine
> parsable so that tools can use it, but it still really should be in the
> code itself, not in some central file that will always just go out of
> data, and will be a huge source of needless patch conflicts.

The downside is that a lot of info will get duplicated. It will be more accurate though.
I agree either way. 

Regards,

	Mariusz
