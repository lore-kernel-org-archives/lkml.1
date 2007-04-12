Return-Path: <linux-kernel-owner+w=401wt.eu-S1946021AbXDLJof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946021AbXDLJof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 05:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946029AbXDLJoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 05:44:34 -0400
Received: from p549F6BD7.dip.t-dialin.net ([84.159.107.215]:24285 "EHLO
	mail.linux-mips.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946053AbXDLJoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 05:44:04 -0400
X-Greylist: delayed 1068 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Apr 2007 05:44:03 EDT
Date: Thu, 12 Apr 2007 11:25:50 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] MIPS:  Replace incorrect "__typeof" with "__typeof__".
Message-ID: <20070412092550.GA686@linux-mips.org>
References: <Pine.LNX.4.64.0704100621550.13136@CPE00045a9c397f-CM001225dbafb6> <20070410120723.GA10409@linux-mips.org> <Pine.LNX.4.64.0704100852150.14789@CPE00045a9c397f-CM001225dbafb6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704100852150.14789@CPE00045a9c397f-CM001225dbafb6>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 08:54:02AM -0400, Robert P. J. Day wrote:

> > > Replace what appears to be an incorrect spelling of "__typeof"
> > > with the correct spelling of "__typeof__".
> >
> > Not a bug, just old fashioned.
> 
> i suspected as much, but i was just going by the docs which explicitly
> mention "__typeof__" but say nothing about "__typeof".  besides, it's
> the *only* non-comment occurrence in the *entire* source tree.  do you
> really want to stand out in a crowd like that?  :-)

Well, that is a different question and indeed is getting a different
answer :-)

  Ralf
