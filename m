Return-Path: <linux-kernel-owner+w=401wt.eu-S1762315AbYCDPF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762315AbYCDPF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 10:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756863AbYCDPFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 10:05:13 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1757 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750941AbYCDPFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:05:12 -0500
Date: Tue, 4 Mar 2008 16:05:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rick van Rein <rick@vanrein.org>
Cc: Ingo Molnar <mingo@elte.hu>, devzero@web.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Message-ID: <20080304150501.GA5310@ucw.cz>
References: <182234194@web.de> <20080304132724.GB32383@elte.hu> <20080304134322.GA19237@phantom.vanrein.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304134322.GA19237@phantom.vanrein.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Please send a patch :-)
> 
> I've been reluctant to quickly mend things because it could lead to
> unstable code.  The patch that I am presenting is mature code, with the
> possible exception of the somewhat newer 64-bit code.  If this list has
> a preference for less mature code that is hardly field-tested, I could
> of course tailor to that.

Clean/small/simple is preferable to 'has been stable for 7 years',
yes.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
