Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbZDPLXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbZDPLXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 07:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbZDPLXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 07:23:38 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:37412 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbZDPLXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 07:23:37 -0400
Date: Thu, 16 Apr 2009 13:25:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: devzero@web.de
Cc: Randy Dunlap <randy.dunlap@oracle.com>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: Should MODULE_DESCRIPTION be mandatory ?
Message-ID: <20090416112543.GA2672@uranus.ravnborg.org>
References: <672387486@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <672387486@web.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> 
> i can offer spending an afternoon (or more) on compiling a list of modulenames + missing description for review.
> if that list is complete and ack`ed, i could create a patch or patch series from that. 
> (maybe the list could be split into logical parts, too)

If you do this then you should feed the patches via the maintainers.
I suggest to start out with the network stuff and see if netdev/David Miller
will take them.

	Sam
