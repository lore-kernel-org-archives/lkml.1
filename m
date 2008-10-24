Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbYJXWgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbYJXWgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 18:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbYJXWfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 18:35:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48384 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbYJXWfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 18:35:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: [BUG] hang with ath5k
Date: Sat, 25 Oct 2008 00:40:23 +0200
User-Agent: KMail/1.9.9
Cc: "Jiri Slaby" <jirislaby@gmail.com>, ath5k-devel@venema.h4ckr.net,
       linux-wireless@vger.kernel.org,
       "kernel list" <linux-kernel@vger.kernel.org>
References: <a8e1da0810140142g633486br12c2799b2fa1670e@mail.gmail.com> <48F6133D.1070508@gmail.com> <a8e1da0810152334x6c596f88i1fd74548dc166f3a@mail.gmail.com>
In-Reply-To: <a8e1da0810152334x6c596f88i1fd74548dc166f3a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810250040.24324.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 16 of October 2008, Dave Young wrote:
> On Wed, Oct 15, 2008 at 11:58 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> > On 10/14/2008 10:42 AM, Dave Young wrote:
> >> 1) run wpa_supplicant
> >> 2) ctrl + C
> >> 3) goto 1)
> >
> > It doesn't happen here. How many iterations in average you need to reproduce this?
> >
> 
> About 15 times for me,
> BTW, wpa_gui running while testing

Is this a regression from 2.6.26?

Rafael
