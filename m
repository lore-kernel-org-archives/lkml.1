Return-Path: <linux-kernel-owner+w=401wt.eu-S1760012AbYBOTLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012AbYBOTLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 14:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbYBOTLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 14:11:48 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:46045 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbYBOTLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 14:11:47 -0500
Date: Fri, 15 Feb 2008 20:11:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH 00/14] [ISDN] HiSax hotplug conversion
Message-ID: <20080215191153.GA3667@uranus.ravnborg.org>
References: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org> <20080215132703.GG1178@uranus.ravnborg.org> <47B5AC27.1030107@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B5AC27.1030107@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> >Just ran checkpatch for the fun of it:
> >total: 28 errors, 86 warnings, 4896 lines checked
> >Most looks easy to fix.
> 
> I'll take a look...  if its checkpatch stuff I caused, I'm happy to fix it.
> 
> But I'm trying to avoid cleanups for pre-existing conditions, i.e. 
> flagged by checkpatch only because I moved existing code to a new location.
> 
> Down that path lies madness and way too much work :)  I didn't sign on 
> to clean up ISDN :)
> 
> Anyway, thanks for the multiple comments, they will be taken into 
> account in the next update of these patches.

I was distracted when halfdone - but I assume that I would just
repeated myself for the rest of the drivers.

When you post an updated version I will try to take a little
bit deeper look. I did not get the full picture of the libification
you have made in hisax.

	Sam
