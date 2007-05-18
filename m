Return-Path: <linux-kernel-owner+w=401wt.eu-S1763314AbXERS1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763314AbXERS1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 14:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbXERS1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 14:27:10 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:41641 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753742AbXERS1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 14:27:09 -0400
Date: Fri, 18 May 2007 14:27:08 -0400
To: Rob Landley <rob@landley.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Tejun Heo <htejun@gmail.com>,
       Dave Jones <davej@redhat.com>, Francesco Pretto <ceztko@gmail.com>,
       Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
Message-ID: <20070518182708.GC10006@csclub.uwaterloo.ca>
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no> <20070517033947.GA24757@khazad-dum.debian.net> <20070517150420.GA10008@csclub.uwaterloo.ca> <200705180316.45969.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705180316.45969.rob@landley.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 03:16:45AM -0400, Rob Landley wrote:
> Because the controller's far more likely to go than the moving parts...

Having redundant everything would be preferable.  But cables do
sometimes fail.  Not sure about the controllers, but if the controller
went you might loose the whole raid.

> On the models I saw they also literally gold plated the connectors, spun the 
> disks faster, and basically did everything they could think of to make the 
> same basic bundle of components more expensive.  (Of course the fundamental 
> thing you do to make it more expensive is have smaller production runs in the 
> first place...)

Well I guess the theory is that a gold plated connector won't corrode as
much so the connection is less likely to fail.  Not sure if there is any
proof to backup that theory.

--
Len Sorensen
