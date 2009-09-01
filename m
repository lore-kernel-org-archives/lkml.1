Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbZIAMoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbZIAMoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 08:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbZIAMoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 08:44:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37830 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbZIAMoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 08:44:10 -0400
Date: Tue, 1 Sep 2009 14:44:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: Data integrity built into the storage stack
Message-ID: <20090901124403.GC1371@ucw.cz>
References: <87f94c370908291423ub92922ft2cceab9e34ac6207@mail.gmail.com> <yq1hbvntf62.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1hbvntf62.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I do agree that we do have to be more prepared for collateral damage
> scenarios.  As we discussed at LS we have 4KB drives coming out that can
> invalidate previously acknowledged I/Os if it gets a subsequent write
> failure on a sector.  And there's also the issue of fractured writes

Hmmm, future will be interesting.

'ext3 expects disks to behave like disks from 1995' (alarming).

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
