Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbXI0NtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbXI0NtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 09:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbXI0NtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 09:49:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43105 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbXI0NtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 09:49:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Norbert Preining <preining@logic.at>
Subject: Re: kernel Oops in ext3 code
Date: Thu, 27 Sep 2007 16:03:03 +0200
User-Agent: KMail/1.9.5
Cc: ext2-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <20070927103122.GB27783@gamma.logic.tuwien.ac.at> <200709271425.06470.rjw@sisk.pl> <20070927131310.GD6093@gamma.logic.tuwien.ac.at>
In-Reply-To: <20070927131310.GD6093@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709271603.04472.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 27 September 2007 15:13, Norbert Preining wrote:
> On Do, 27 Sep 2007, Rafael J. Wysocki wrote:
> > Does it happen with 2.6.22?
> 
> Hard to say. It didn't happen as long as I used -22, but it didn't
> happen for a long time (since I run -rc6), and it is not reproducible.
> 
> What I did at this time is a:
> 	tar -cjf foo.tar.bz2 a-big-dir-with-more-than-800Mb
> I retried it again with -rc6 and it succeeded. So hard to say.
> 
> Best wishes

Thanks.

Let's assume it's not a regression from 2.6.22, then. ;-)

Greetings,
Rafael
