Return-Path: <linux-kernel-owner+w=401wt.eu-S1755696AbYFCRfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbYFCRfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbYFCRfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:35:10 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2823 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754881AbYFCRfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:35:08 -0400
Date: Tue, 3 Jun 2008 18:12:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Rick van Rein <rick@groengemak.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Future Linux on Bistable Storage
Message-ID: <20080603161244.GA4177@ucw.cz>
References: <20080602125904.GA15129@phantom.vanrein.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080602125904.GA15129@phantom.vanrein.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> But in the end I expect the entire system to switch itself off in between
> every two keystrokes (!) simply because loosing no data anywhere in the
> system means being able to resume operations at the next whim/interrupt.

Some of todays devices are designed to sleep between keystrokes,
including cellphones and olpc notebook. It is doable in todays
hardware... and my sleepy linux patches aim to do something like that.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
