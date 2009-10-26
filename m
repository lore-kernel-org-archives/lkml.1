Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbZJZT6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbZJZT6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbZJZT6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:58:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60143 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbZJZT6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:58:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Stuge <peter@stuge.se>
Subject: Re: no video output after suspend after "drm/i915: force mode set at lid open time"
Date: Mon, 26 Oct 2009 21:00:21 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>,
       linux-kernel@vger.kernel.org, mjg@redhat.com, eric@anholt.net
References: <4AE4BBBC.2070809@gmail.com> <200910262039.58626.rjw@sisk.pl> <20091026194202.29175.qmail@stuge.se>
In-Reply-To: <20091026194202.29175.qmail@stuge.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910262100.21870.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 October 2009, Peter Stuge wrote:
> Rafael J. Wysocki wrote:
> > > > can you give it a try and see if it works for you?
> > > 
> > > It works beautifully. Fantastic. Thank you very much! It was marked
> > > Accepted in patchwork but if you need one then here's a:
> > > 
> > > Tested-by: Peter Stuge <peter@stuge.se>
> > 
> > A link to the patch, please?
> 
> Sorry about that!
> 
> http://patchwork.kernel.org/patch/53783/
> 
> Had to apply it manually onto drm-intel.git, but no big deal for me.

OK, thanks.

Rafael
