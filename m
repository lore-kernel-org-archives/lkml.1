Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbZKJUvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbZKJUvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758081AbZKJUvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:51:18 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41305 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758074AbZKJUvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:51:18 -0500
Date: Tue, 10 Nov 2009 21:51:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Paul Fertser <fercerpav@gmail.com>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, zaurus-devel@www.linuxtogo.org
Subject: Re: [RFC PATCH 1/2] power: implement platform battery driver
Message-ID: <20091110205111.GA1476@ucw.cz>
References: <1257820673-30801-1-git-send-email-fercerpav@gmail.com> <1257820673-30801-2-git-send-email-fercerpav@gmail.com> <20091110132129.GB26144@atrey.karlin.mff.cuni.cz> <20091110162235.GA22476@home.pavel.comp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110162235.GA22476@home.pavel.comp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > + * Use consistent with the GNU GPL is permitted, provided that this
> > > + * copyright notice is preserved in its entirety in all copies and derived
> > > + * works.
> > 
> > gpl with additional restrictions? can we get standard gplv2 header?
> 
> Yep, sure. Sorry, that's a dumb copy/paste from the old Balaji driver.

Thanks.

I do not think I want to use it for zauruses. Battery API is easy
enough to implement, and I need some advanced features. Also zauruses
are similar to each other, so driver<->platform interface needs to be
elsewhere.

Anyway, code looks good from quick look, so good luck :-).
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
