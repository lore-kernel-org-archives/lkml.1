Return-Path: <linux-kernel-owner+w=401wt.eu-S934024AbYBHEJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934024AbYBHEJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 23:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758060AbYBHEJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 23:09:33 -0500
Received: from mx1.suse.de ([195.135.220.2]:48738 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192AbYBHEJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 23:09:31 -0500
Date: Thu, 7 Feb 2008 20:11:16 -0800
From: Greg KH <gregkh@suse.de>
To: Kevin Lloyd <klloyd@sierrawireless.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, linux-usb@vger.kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bruno Redondi <bruno.redondi@altarisoluzione.com>
Subject: Re: [patch 13/45] USB: sierra: add support for Onda H600/Zte
	MF330datacard to USB Driver for Sierra Wireless
Message-ID: <20080208041116.GA8122@suse.de>
References: <20080207204118.202098927@mini.kroah.org> <20080207204708.GN16389@suse.de> <3415E2A2AB26944B9159CDB22001004D023D61F1@nestea.sierrawireless.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3415E2A2AB26944B9159CDB22001004D023D61F1@nestea.sierrawireless.local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 06:21:55PM -0800, Kevin Lloyd wrote:
> > 2.6.24-stable review patch.  If anyone has any objections, please let
> us
> > know.
> > 
> > ------------------
> > From: Bruno Redondi <bruno.redondi@altarisoluzione.com>
> > 
> > Added support for Onda H600/Zte MF330 GPRS/UMTS/HSDPA datacard
> 
> Per our earlier discussion we probably don't want to have this one in
> the Sierra driver.

For now, yes, we should mirror what is going to be in the 2.6.25 kernel
release.  I see the split happening for 2.6.26.  So I say leave this for
now, it adds support for users of these devices.

thanks,

greg k-h
