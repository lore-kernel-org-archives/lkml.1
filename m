Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497Ab0AMVuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab0AMVuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069Ab0AMVt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:49:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754792Ab0AMVt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:49:58 -0500
Date: Wed, 13 Jan 2010 13:45:16 -0800
From: Greg KH <gregkh@suse.de>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: Thomas Voegtle <tv@lio96.de>, Jan Kara <jack@suse.cz>,
       "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, dmonakhov@openvz.org
Subject: Re: Linux 2.6.31.10
Message-ID: <20100113214516.GC11701@suse.de>
References: <20100106234533.GC1960@kroah.com>
 <alpine.LNX.2.00.1001071522480.5426@er-systems.de>
 <20100107180449.GA17495@suse.de>
 <alpine.LNX.2.00.1001072033301.26784@er-systems.de>
 <20100107194131.GA22983@suse.de>
 <alpine.LNX.2.00.1001072125040.26784@er-systems.de>
 <alpine.LNX.2.00.1001072141340.26784@er-systems.de>
 <20100107220213.GA24882@suse.de>
 <4B4E37D7.3010706@pardus.org.tr>
 <4B4E387B.2050900@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B4E387B.2050900@pardus.org.tr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 11:17:47PM +0200, Ozan Çağlayan wrote:
> Ozan Çağlayan wrote:
> 
> > This causes kernel panic upon boot on one of our users' ext3 system (on 2.6.31.11) so I think 2.6.30.y deserves another
> > stable update to fix this critical issue.
> 
> oops, 2.6.30.y should be 2.6.31.y, sorry.

Yes, .31 will be getting another release with this fix in it, sorry for
the delay, been stuck debugging other things these past few days...

thanks,

greg k-h
