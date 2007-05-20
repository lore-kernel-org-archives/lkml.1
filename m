Return-Path: <linux-kernel-owner+w=401wt.eu-S1759961AbXETJOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961AbXETJOg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 05:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbXETJO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 05:14:28 -0400
Received: from mail.suse.de ([195.135.220.2]:41212 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbXETJO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 05:14:27 -0400
From: Andreas Schwab <schwab@suse.de>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Willy Tarreau <w@1wt.eu>, oliver pinter <oliver.pntr@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, xfs-masters@oss.sgi.com,
       Bernd Eckenfels <ecki@lina.inka.de>
Subject: Re: it seems at XFS bug?!
References: <6101e8c40705191117h40c8af70sfc9d0617a99a248b@mail.gmail.com>
	<E1HpUNW-00020n-00@calista.eckenfels.net>
	<20070519192021.GK943@1wt.eu> <20070519192246.GA11733@1wt.eu>
	<6101e8c40705191237v46939bf1i7098fc974784de5a@mail.gmail.com>
	<6101e8c40705191250o447e9c59kba824baae4d99b3f@mail.gmail.com>
	<20070519202419.GC2521@1wt.eu>
	<Pine.LNX.4.61.0705201038250.9015@yvahk01.tjqt.qr>
X-Yow: "DARK SHADOWS" is on!!  Hey, I think the VAMPIRE forgot his UMBRELLA!!
Date: Sun, 20 May 2007 11:14:22 +0200
In-Reply-To: <Pine.LNX.4.61.0705201038250.9015@yvahk01.tjqt.qr> (Jan
	Engelhardt's message of "Sun\, 20 May 2007 10\:39\:33 +0200 \(MEST\)")
Message-ID: <jey7jjx3f5.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@linux01.gwdg.de> writes:

> On May 19 2007 22:24, Willy Tarreau wrote:
>>On Sat, May 19, 2007 at 09:50:43PM +0200, oliver pinter wrote:
>>> yeah, but how produziert?
>>
>>I *think* it is the unbreakable space.
>
> \xa0 is 160, aka the NBSP. But __only__ in ISO-8859. It is an invalid
> UTF-8 sequence (which is why you may not even "see" the nbsp :-)

Actually, in a utf-8 environment you see it much better.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
