Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbXH2SMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbXH2SMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 14:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbXH2SLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 14:11:54 -0400
Received: from main.carme.maven.pl ([193.239.45.138]:15271 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbXH2SLx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 14:11:53 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Organization: SelfOrganizing
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.22 oops kernel BUG at block/elevator.c:366!
Date: Wed, 29 Aug 2007 20:11:46 +0200
User-Agent: PLD Linux KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200708291950.14513.arekm@maven.pl> <200708292004.36426.arekm@maven.pl> <20070829180800.GC7932@kernel.dk>
In-Reply-To: <20070829180800.GC7932@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708292011.47134.arekm@maven.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 of August 2007, Jens Axboe wrote:
> On Wed, Aug 29 2007, Arkadiusz Miskiewicz wrote:
> > On Wednesday 29 of August 2007, Jens Axboe wrote:
> > > On Wed, Aug 29 2007, Arkadiusz Miskiewicz wrote:
> > > > I guess I should sent these here since it looks like not scsi bug
> > > > anyway.
> > >
> > > It's stex, right? It seems to have some issues with multiple
> > > completions of commands, which craps out the block layer of course.
> >
> > Yes, stex. I'm staying with 2.6.19 in that case since it works fine in
> > that version.
> >
> > So scsi bug ... 8-)
>
> And you based that conclusion on what exactly?

Isn't drivers/scsi/* handled by linux-scsi@? (that's what I mean)

-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
