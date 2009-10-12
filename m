Return-Path: <linux-kernel-owner+w=401wt.eu-S933224AbZJLVhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224AbZJLVhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933166AbZJLVhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:37:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36305 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757871AbZJLVhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:37:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Santiago Garcia Mantinan <manty@manty.net>
Subject: Re: [Bug #14294] kernel BUG at drivers/ide/ide-disk.c:187
Date: Mon, 12 Oct 2009 23:38:29 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, bzolnier@gmail.com
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <20091012.035126.264745627.davem@davemloft.net> <20091012120943.GA2625@dis.manty.net>
In-Reply-To: <20091012120943.GA2625@dis.manty.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910122338.29949.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 October 2009, Santiago Garcia Mantinan wrote:
> Hi!
> 
> > I gave the user a debugging patch, but they reported that they
> > can no longer trigger the issue with 2.6.31.1
> > 
> > See:
> > 
> > 	http://marc.info/?l=linux-ide&m=125469615425454&w=4
> > 
> > Maybe that's enough to close this, I dunno.
> 
> I'm the user with the debugging patch, I'd say no, don't close it.

OK, still open.

Thanks for the update.

Rafael
