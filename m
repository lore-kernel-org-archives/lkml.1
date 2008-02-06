Return-Path: <linux-kernel-owner+w=401wt.eu-S1759335AbYBFTyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335AbYBFTyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 14:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbYBFTyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 14:54:12 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:27485 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534AbYBFTyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 14:54:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=pEgcFev4JICLrzHvEVjorF+E8hKB0wJrOYGKyNsr1qFdPd/HnqPPri04a9YkIVqi3dxwQ3ssGhuiCOHgewDw1dFIEN8MjDJKMMOLWWd4pY4BxooDz2v0IOgRS3+LYCdatJk7H9srAcL/WrgGyvZBCgM2CSNi9WSq+P1yoHtsD1o=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: feature-removal-schedule.txt is getting out of date again
Date: Wed, 6 Feb 2008 21:07:55 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
References: <alpine.LFD.1.00.0802060419140.17178@localhost.localdomain> <200802062054.59755.bzolnier@gmail.com> <1202327360.5820.24.camel@brick>
In-Reply-To: <1202327360.5820.24.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802062107.56084.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 February 2008, Harvey Harrison wrote:
> On Wed, 2008-02-06 at 20:54 +0100, Bartlomiej Zolnierkiewicz wrote:
> > Hi,
> > 
> > On Wednesday 06 February 2008, Robert P. J. Day wrote:
> > > 
> > >   yes, i realize i'm sounding like a broken record but, once again,
> > > Documentation/feature-removal-schedule.txt is slipping out of date WRT
> > > items that are now slightly, if not noticeably, behind schedule for
> > > removal.
> > 
> 
> I had pinged people about a week ago on lots of these items, for the
> most part patches are staged and going in through various trees, let's
> wait for rc1 and see what has landed by then.

OK, great to see that it is being dealt with.

Thanks,
Bart
