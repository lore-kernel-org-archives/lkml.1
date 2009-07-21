Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbZGUWiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbZGUWiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 18:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756406AbZGUWiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 18:38:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33701 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbZGUWiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 18:38:02 -0400
Date: Wed, 22 Jul 2009 00:37:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andy Whitcroft <apw@canonical.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch whitespace
Message-ID: <20090721223739.GB29955@elf.ucw.cz>
References: <20090721100113.GC4133@elf.ucw.cz> <200907221305.28115.bzolnier@gmail.com> <20090721130618.GP12122@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090721130618.GP12122@shadowen.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-07-21 14:06:18, Andy Whitcroft wrote:
> On Wed, Jul 22, 2009 at 01:05:27PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Tuesday 21 July 2009 12:01:14 Pavel Machek wrote:
> > 
> > > Would it be possible to add autofixing to checkpatch? Fixing
> > > whitespace issues by hand is useless & boring task...
> > 
> > That's why most people use scripts for it.. ;)
> > 
> > scripts/cleanfile
> > scripts/cleanpatch
> > 
> > Maybe we should make checkpatch inform people about them
> > (if any whitespace errors were detected)..
> 
> That sounds like a good idea.  Will have a look at doing that.

Yes, that would be great. Thanks!

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
