Return-Path: <linux-kernel-owner+w=401wt.eu-S1759952AbZDKXPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952AbZDKXPz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 19:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759384AbZDKXPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 19:15:47 -0400
Received: from thunk.org ([69.25.196.29]:36280 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759319AbZDKXPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 19:15:46 -0400
Date: Sat, 11 Apr 2009 18:33:11 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: suspend-to-ram broken on X61 thinkpads in 2.6.30-rc1?
Message-ID: <20090411223311.GA10547@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Jeff Chua <jeff.chua.linux@gmail.com>, Pavel Machek <pavel@ucw.cz>,
	linux-kernel@vger.kernel.org
References: <E1Ls9pZ-0004IF-FZ@closure.thunk.org> <900814656-1239422746-cardhu_decombobulator_blackberry.rim.net-2124207137-@bxe1152.bisx.prod.on.blackberry> <b6a2187b0904102158r5e37860cw2f45bee5578ebcf0@mail.gmail.com> <200904111251.49396.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904111251.49396.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 12:51:48PM +0200, Rafael J. Wysocki wrote:
> 
> Great, thanks for checking this.
> 
> Ted, can you please see if the current -git fixed the problem for you too?
> 

Confirmed, it seems to be fixed.

						- Ted
