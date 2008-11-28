Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbYK1JsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbYK1JsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 04:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYK1JsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 04:48:06 -0500
Received: from mail.gmx.net ([213.165.64.20]:46272 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750900AbYK1JsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 04:48:05 -0500
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX18Wv2gPJDMW4/do6J4q63+nNKQqqYv2Rfad/Mu7l8
	Rt1WfZ07cFw+V7
From: "Jan-Simon =?iso-8859-1?q?M=F6ller?=" <dl9pf@gmx.de>
To: Rob Landley <rob@landley.net>
Subject: Re: Document hadling of bad memory
Date: Fri, 28 Nov 2008 10:47:57 +0100
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       mtk.manpages@gmail.com, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>,
       Trivial patch monkey <trivial@kernel.org>
References: <20081126161521.GC1983@elf.ucw.cz> <200811280300.26969.rob@landley.net>
In-Reply-To: <200811280300.26969.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811281047.57882.dl9pf@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 28 November 2008 10:00:26 schrieb Rob Landley:
> 
> So the patch isn't worth merging, but documentation about the out-of-tree 
> patch is worth merging?
Good point.

IIRC we tried merging the patch, but without luck at that time. It was said, that there's another method
(with an even <irony>better</irony> syntax) which could also handle this case and there should be better 
some hacking to get the syntax parsed to use the functions of this already in-kernel method.
I don't know the status of this (guess: none). 
What I know: badmem worked here really good. (But meantime I bought new ram.)

Best regards,
Jan-Simon
