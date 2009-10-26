Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbZJZTiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbZJZTiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbZJZTiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:38:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59769 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401AbZJZTiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:38:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Stuge <peter@stuge.se>
Subject: Re: no video output after suspend after "drm/i915: force mode set at lid open time"
Date: Mon, 26 Oct 2009 20:39:58 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>,
       linux-kernel@vger.kernel.org, mjg@redhat.com, eric@anholt.net
References: <4AE4BBBC.2070809@gmail.com> <20091026090234.32ae7656@jbarnes-g45> <20091026192839.22901.qmail@stuge.se>
In-Reply-To: <20091026192839.22901.qmail@stuge.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910262039.58626.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 October 2009, Peter Stuge wrote:
> Jesse Barnes wrote:
> > > Can I help solve this somehow?
> > 
> > I posted a patch that fixed an X40 I was testing:
> > drm/i915: save/restore BLC histogram control reg across suspend/resume
> > 
> > can you give it a try and see if it works for you?
> 
> It works beautifully. Fantastic. Thank you very much! It was marked
> Accepted in patchwork but if you need one then here's a:
> 
> Tested-by: Peter Stuge <peter@stuge.se>

A link to the patch, please?

Rafael
