Return-Path: <linux-kernel-owner+w=401wt.eu-S1756457AbZJZTmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457AbZJZTmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756446AbZJZTl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:41:59 -0400
Received: from foo.birdnet.se ([213.88.146.6]:45670 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756371AbZJZTl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:41:58 -0400
Message-ID: <20091026194202.29175.qmail@stuge.se>
Date: Mon, 26 Oct 2009 20:42:02 +0100
From: Peter Stuge <peter@stuge.se>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>,
       linux-kernel@vger.kernel.org, mjg@redhat.com, eric@anholt.net
Subject: Re: no video output after suspend after "drm/i915: force mode set
	at lid open time"
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>,
	linux-kernel@vger.kernel.org, mjg@redhat.com, eric@anholt.net
References: <4AE4BBBC.2070809@gmail.com> <20091026090234.32ae7656@jbarnes-g45> <20091026192839.22901.qmail@stuge.se> <200910262039.58626.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910262039.58626.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> > > can you give it a try and see if it works for you?
> > 
> > It works beautifully. Fantastic. Thank you very much! It was marked
> > Accepted in patchwork but if you need one then here's a:
> > 
> > Tested-by: Peter Stuge <peter@stuge.se>
> 
> A link to the patch, please?

Sorry about that!

http://patchwork.kernel.org/patch/53783/

Had to apply it manually onto drm-intel.git, but no big deal for me.


//Peter
