Return-Path: <linux-kernel-owner+w=401wt.eu-S1760727AbZATKL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727AbZATKL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 05:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755532AbZATKLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 05:11:47 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41337 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbZATKLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 05:11:46 -0500
Date: Tue, 20 Jan 2009 11:13:49 +0100
From: Pavel Machek <pavel@suse.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Trivial patch monkey <trivial@kernel.org>, eric.piel@tremplin-utc.net
Subject: Re: lis3: fix documentation to fit into 80 columns
Message-ID: <20090120101348.GI2576@elf.ucw.cz>
References: <20090114172013.GA25948@elf.ucw.cz> <alpine.LNX.1.10.0901200027050.5377@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0901200027050.5377@jikos.suse.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-01-20 00:29:40, Jiri Kosina wrote:
> On Wed, 14 Jan 2009, Pavel Machek wrote:
> 
> >  Sysfs attributes under /sys/devices/platform/lis3lv02d/:
> >  position - 3D position that the accelerometer reports. Format: "(x,y,z)"
> > -calibrate - read: values (x, y, z) that are used as the base for input class device operation.
> > -            write: forces the base to be recalibrated with the current position.
> > +calibrate - read: values (x, y, z) that are used as the base for input
> > +		  class device operation.
> > +            write: forces the base to be recalibrated with the current
> > +		  position.
> 
> I don't seem to be able to figure out what indentation is being used here. 
> Why two tabs and two spaces? It doesn't align with anything this way.

Added one more space :-), and fixed indentation in another place,
too. Will push with next updates...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
