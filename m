Return-Path: <linux-kernel-owner+w=401wt.eu-S932419AbZACEvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbZACEvB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 23:51:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757211AbZACEuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 23:50:52 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:64065 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbZACEuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 23:50:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dBhtge8HxuUwHO7xUCEtg9VBf0QUmsyj4IqzoDih3tCmU22dKb5k2C36nHNUMUySxo
         RJPUL6SNIM06h9b6qkEGIxfkaW2DmEsJEDaOPJdyQyMkKmsjdY2L2vuo+IHFCyF37fz4
         WdmGhLSeqzGNzQvrnUDB28KdIjPQKuxP5Za34=
Message-ID: <8752a8760901022050v4541c66yee627ee4fcec880b@mail.gmail.com>
Date: Sat, 3 Jan 2009 04:50:50 +0000
From: "Ben Goodger" <goodgerster@gmail.com>
To: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Cc: linasvepstas@gmail.com, linux-kernel@vger.kernel.org,
       "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       "Travis Crump" <pretzalz@techhouse.org>, burdell@iruntheinter.net
In-Reply-To: <e9e943910901022046y436b39ay72ae7b898c0fe26f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
	 <3ae3aa420901021949m1df64dadh693ad39618476524@mail.gmail.com>
	 <8752a8760901022002n7cd269a1k1073df66d0d2b08d@mail.gmail.com>
	 <e9e943910901022046y436b39ay72ae7b898c0fe26f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/3 Duane Griffin <duaneg@dghda.com>:
> Thanks, but I'm not the one who deserves the thanks: Chris Adams did
> all the work in reproducing and diagnosing the problem. My patch was
> entirely trivial (and indeed, incomplete).

I mean 2009-_12_-31, of course.
Thank you, Mr Adams...

-- 
Benjamin Goodger

-----BEGIN GEEK CODE BLOCK-----
Version: 3.1
GCS/S/M/B d- s++:-- a18 c++$ UL>+++ P--- L++>+++ E- W+++$ N--- K? w---
O? M- V? PS+(++) PE-() Y+ PGP+ t 5? X-- R- !tv() b+++>++++ DI+++ D+ G
e>++++ h! !r*(-) y
------END GEEK CODE BLOCK------
