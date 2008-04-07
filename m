Return-Path: <linux-kernel-owner+w=401wt.eu-S1758760AbYDGOP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbYDGOP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 10:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbYDGOPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 10:15:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:41251 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbYDGOPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 10:15:20 -0400
Date: Mon, 7 Apr 2008 16:15:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: =?iso-8859-2?Q?K=E1roly?= Kasza <kaszak@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, lcostantino@gmail.com,
       someone@dunanet.hu
Subject: Re: w35und: cleanup wbusb.c a bit
Message-ID: <20080407141519.GA23887@atrey.karlin.mff.cuni.cz>
References: <20080403000321.GA5013@elf.ucw.cz> <544ab8580804030410r5f2b90ffpfcde9e7d2ed3860e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544ab8580804030410r5f2b90ffpfcde9e7d2ed3860e@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I comitted your wbusb.c clean ups as rev15. Thank you!
> Also still planning to rewrite the driver (based on Softmac maybe),
> your help will be appreciated if we ever get there :)

That makes a lot of sense, yes. I guess I'll do some more small
cleanups if you don't mind: reimplementing clean code under softmac
should be easier than reimplementing ugly code...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
