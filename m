Return-Path: <linux-kernel-owner+w=401wt.eu-S1764320AbXESUYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764320AbXESUYe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 16:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758201AbXESUY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 16:24:27 -0400
Received: from 1wt.eu ([62.212.114.60]:2699 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756479AbXESUY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 16:24:27 -0400
Date: Sat, 19 May 2007 22:24:19 +0200
From: Willy Tarreau <w@1wt.eu>
To: oliver pinter <oliver.pntr@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, xfs-masters@oss.sgi.com,
       Bernd Eckenfels <ecki@lina.inka.de>
Subject: Re: it seems at XFS bug?!
Message-ID: <20070519202419.GC2521@1wt.eu>
References: <6101e8c40705191117h40c8af70sfc9d0617a99a248b@mail.gmail.com> <E1HpUNW-00020n-00@calista.eckenfels.net> <20070519192021.GK943@1wt.eu> <20070519192246.GA11733@1wt.eu> <6101e8c40705191237v46939bf1i7098fc974784de5a@mail.gmail.com> <6101e8c40705191250o447e9c59kba824baae4d99b3f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6101e8c40705191250o447e9c59kba824baae4d99b3f@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 at 09:50:43PM +0200, oliver pinter wrote:
> yeah, but how produziert?

I *think* it is the unbreakable space. Maybe you can enter it on
your keyboard using AltGr-spacebar or something like this. If this
is the case, it's possible that you got it right after a '>' during
a command like below :

   # foo >_ bar

with this character instead of the '_' above.

Regards,
Willy

