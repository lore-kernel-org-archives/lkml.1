Return-Path: <linux-kernel-owner+w=401wt.eu-S1762027AbXFJVPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762027AbXFJVPd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 17:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbXFJVPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 17:15:24 -0400
Received: from main.gmane.org ([80.91.229.2]:58930 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbXFJVPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 17:15:24 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: James Bruce <bruce@andrew.cmu.edu>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Sun, 10 Jun 2007 17:15:04 -0400
Message-ID: <466C69D8.7030401@andrew.cmu.edu>
References: <466A3EC6.6030706@netone.net.tr>  <18026.16739.228277.938421@notabene.brown>  <20070609071231.GL2649@lug-owl.de> <466BB9B0.5030908@netone.net.tr>  <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>  <466BCBBC.90305@netone.net.tr>  <Pine.LNX.4.64.0706100301520.6675@asgard.lang.hm> <f24d23310706100355j3af7e12fq2e0e345402e48ca2@mail.gmail.com> <466C0901.4000405@netone.net.tr> <alpine.LFD.0.98.0706101025330.20321@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: Tarkan Erimer <tarkan@netone.net.tr>,
       debian developer <debiandev@gmail.com>, "david@lang.hm" <david@lang.hm>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu, greg@kroah.com
X-Gmane-NNTP-Posting-Host: dhcp-7-156.dsl.telerama.com
User-Agent: Icedove 1.5.0.10 (X11/20070329)
In-Reply-To: <alpine.LFD.0.98.0706101025330.20321@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
[ snip ]
> I consider dual-licensing unlikely (and technically quite hard), but at 
> least _possible_ in theory. I have yet to see any actual *reasons* for 
> licensing under the GPLv3, though.
[ snip ]

One thing that would make that easier in the future is if contributers
at least started to dual-license their submissions.  I.e. if instead
of "GPL version 2", one could say "GPL version 2 or GPL version 3".
It isn't the same thing as the problematic "GPL version 2 or later",
because the developer is not agreeing to an unseen license (GPLv4,
etc).  What it does do is make it easier to move to GPLv3 a few years
from now, if that is decided then, as a significant fraction of the
code will already be GPLv3 compatible.  That way, if a reason is ever
found to move to v3, at least some of the work will already be done.

  - Jim Bruce

