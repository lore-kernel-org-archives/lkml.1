Return-Path: <linux-kernel-owner+w=401wt.eu-S1758455AbZABUDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455AbZABUDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 15:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758593AbZABUDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 15:03:22 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:52981 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759164AbZABUDU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 15:03:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=jWTenjloddZj9DDiPHvhkIg0/wbW2DZt3HvqHEMXNvOmiFy3Z1bCGQkFPDrXnDojJI
         wn/8J9stW0NJ5A7n/MelO1BxGo6inMSVEgMyvfNPmgu7J4Rbwf27slFPrbH1ihdykISY
         DGfOX2xJcHAcyKVh3IslCy6BG4KDw0ODgDDOg=
Date: Fri, 2 Jan 2009 21:04:30 +0100
From: Diego Calleja <diegocg@gmail.com>
To: linasvepstas@gmail.com
Cc: linux-kernel@vger.kernel.org, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       "Travis Crump" <pretzalz@techhouse.org>,
       Goodgerster <goodgerster@gmail.com>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
Message-ID: <20090102210430.49649261@diego-desktop>
In-Reply-To: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Fri, 2 Jan 2009 13:25:38 -0600, "Linas Vepstas" <linasvepstas@gmail.com> escribió:

> Suspect its an kernel race condition triggered by ntp bumping the second.

How could I create a test case that reproduces what ntp does? Just add
a second?
