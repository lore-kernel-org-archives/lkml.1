Return-Path: <linux-kernel-owner+w=401wt.eu-S1760667AbZATKQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667AbZATKQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 05:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755698AbZATKQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 05:16:19 -0500
Received: from styx.suse.cz ([82.119.242.94]:56432 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755208AbZATKQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 05:16:18 -0500
Date: Tue, 20 Jan 2009 11:16:17 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Pavel Machek <pavel@suse.cz>
cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Trivial patch monkey <trivial@kernel.org>, eric.piel@tremplin-utc.net
Subject: Re: lis3: fix documentation to fit into 80 columns
In-Reply-To: <20090120101348.GI2576@elf.ucw.cz>
Message-ID: <alpine.LNX.1.10.0901201115090.5377@jikos.suse.cz>
References: <20090114172013.GA25948@elf.ucw.cz> <alpine.LNX.1.10.0901200027050.5377@jikos.suse.cz> <20090120101348.GI2576@elf.ucw.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2009, Pavel Machek wrote:

> > >  Sysfs attributes under /sys/devices/platform/lis3lv02d/:
> > >  position - 3D position that the accelerometer reports. Format: "(x,y,z)"
> > > -calibrate - read: values (x, y, z) that are used as the base for input class device operation.
> > > -            write: forces the base to be recalibrated with the current position.
> > > +calibrate - read: values (x, y, z) that are used as the base for input
> > > +		  class device operation.
> > > +            write: forces the base to be recalibrated with the current
> > > +		  position.
> > I don't seem to be able to figure out what indentation is being used here. 
> > Why two tabs and two spaces? It doesn't align with anything this way.
> Added one more space :-), and fixed indentation in another place,
> too. Will push with next updates...

Never mind, I have noticed that it's already in Linus' tree even with the 
little bit wonky formatting, so I am not going to take it to trivial tree 
anyway.

Thanks,

-- 
Jiri Kosina
