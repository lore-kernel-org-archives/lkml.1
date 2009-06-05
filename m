Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbZFELvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbZFELvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 07:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbZFELvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 07:51:07 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60692 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbZFELvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 07:51:06 -0400
Date: Fri, 5 Jun 2009 13:51:01 +0200 (CEST)
From: Jesper Dangaard Brouer <hawk@diku.dk>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Sergey Lapin <slapin@ossfans.org>, David Miller <davem@davemloft.net>,
       johannes@sipsolutions.net, linux-kernel@vger.kernel.org,
       netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
       sfr@canb.auug.org.au
Subject: Re: [PATCH 3/5] net: add NL802154 interface for configuration of 
 802.15.4 devices
In-Reply-To: <bc64b4640906050345t5ed23d7bxc8a777a4a0ada147@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0906051345250.1757@ask.diku.dk>
References: <1244168990-28355-4-git-send-email-dbaryshkov@gmail.com> 
 <1244184737.22576.94.camel@johannes.local>  <20090605071529.GA7064@doriath.ww600.siemens.net>
  <20090605.005418.07362083.davem@davemloft.net>  <20090605091229.GA25280@doriath.ww600.siemens.net>
  <20090605094619.GB23085@build.ossfans.org>
 <bc64b4640906050345t5ed23d7bxc8a777a4a0ada147@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009, Dmitry Eremin-Solenikov wrote:

> Could you please send an incremental patch on top of this serie? I
> hope that my last
> push can be pulled/merged and I don't want to redo all commits.

I would recommend that you use StGit (http://www.procode.org/stgit/) as it 
makes it a lot easier to incorporate change requests/feedback as you can 
modify the individual git commits directly.

Cheers,
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
