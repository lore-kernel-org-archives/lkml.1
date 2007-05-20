Return-Path: <linux-kernel-owner+w=401wt.eu-S1760577AbXETJV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577AbXETJV3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 05:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbXETJVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 05:21:21 -0400
Received: from 1wt.eu ([62.212.114.60]:2705 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbXETJVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 05:21:20 -0400
Date: Sun, 20 May 2007 11:21:08 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: oliver pinter <oliver.pntr@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, xfs-masters@oss.sgi.com,
       Bernd Eckenfels <ecki@lina.inka.de>
Subject: Re: it seems at XFS bug?!
Message-ID: <20070520092106.GL943@1wt.eu>
References: <6101e8c40705191117h40c8af70sfc9d0617a99a248b@mail.gmail.com> <E1HpUNW-00020n-00@calista.eckenfels.net> <20070519192021.GK943@1wt.eu> <20070519192246.GA11733@1wt.eu> <6101e8c40705191237v46939bf1i7098fc974784de5a@mail.gmail.com> <6101e8c40705191250o447e9c59kba824baae4d99b3f@mail.gmail.com> <20070519202419.GC2521@1wt.eu> <Pine.LNX.4.61.0705201038250.9015@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705201038250.9015@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 10:39:33AM +0200, Jan Engelhardt wrote:
> 
> On May 19 2007 22:24, Willy Tarreau wrote:
> >On Sat, May 19, 2007 at 09:50:43PM +0200, oliver pinter wrote:
> >> yeah, but how produziert?
> >
> >I *think* it is the unbreakable space.
> 
> \xa0 is 160, aka the NBSP. But __only__ in ISO-8859. It is an invalid
> UTF-8 sequence (which is why you may not even "see" the nbsp :-)

An even better reason is to be in ISO-8859 :-)

Willy

