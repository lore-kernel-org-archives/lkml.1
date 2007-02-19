Return-Path: <linux-kernel-owner+w=401wt.eu-S1161068AbXBTXXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161068AbXBTXXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 18:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161078AbXBTXXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 18:23:24 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48050 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161068AbXBTXXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 18:23:23 -0500
Date: Mon, 19 Feb 2007 23:20:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       Nigel Cunningham <ncunningham@linuxmail.org>,
       Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Documentation: Ask driver writers to provide PM support
Message-ID: <20070219222033.GA21199@elf.ucw.cz>
References: <200702192311.36710.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702192311.36710.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Add a paragraph in Documentation/SubmittingDrivers requesting that the
> basic PM support be provided by new device drivers.
> 
> Add two new documents in Documentation/power/ giving general instructions on
> debugging the suspend/resume functionality and testing the suspend and resume
> support in device drivers.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  Documentation/SubmittingDrivers            |   15 ++++
>  Documentation/power/basic-pm-debugging.txt |  106 +++++++++++++++++++++++++++++
>  Documentation/power/drivers-testing.txt    |   42 +++++++++++
>  3 files changed, 163 insertions(+)

ACK.

> +		drivers see Documentation/power/drivers.txt .


Does this file exist for you? Should it exist for me? (I have pretty
current -git here...)

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
