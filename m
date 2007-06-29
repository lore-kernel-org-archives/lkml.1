Return-Path: <linux-kernel-owner+w=401wt.eu-S932701AbXF2Oec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbXF2Oec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 10:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760838AbXF2OeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 10:34:25 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:51776
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758332AbXF2OeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 10:34:24 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Michael Kerrisk" <mtk-manpages@gmx.net>
Subject: Re: man-pages-2.59 and man-pages-2.60 are released
Date: Fri, 29 Jun 2007 10:33:10 -0400
User-Agent: KMail/1.9.6
Cc: Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org,
       patrakov@ums.usu.ru
References: <467F8FCF.4080009@gmx.net> <46843B9B.2080700@tmr.com> <20070629083021.58530@gmx.net>
In-Reply-To: <20070629083021.58530@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706291033.11221.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 June 2007 04:30:21 Michael Kerrisk wrote:
> > You could have a link in
> > "Old" as requested, and any other links as well.
>
> Well, I think all that LFS seems to want is links that are
> stable "for a while" (since I don't suppose that they want
> to use really old tarballs in any case).

What I did in busybox is uploaded it into "old" at the same time I uploaded it 
into the directory above that, and then deleted it out of the upper directory 
when I no longer recommended anybody use it.  But old provided a stable link 
from day 1.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
