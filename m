Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbYIKJX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbYIKJX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 05:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbYIKJXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 05:23:50 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40739 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbYIKJXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 05:23:50 -0400
Date: Thu, 11 Sep 2008 12:21:56 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
       Janne Grunau <j@jannau.net>, Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 04/18] lirc driver for 2nd-gen and later Media Center
	Ed. USB IR transceivers
Message-ID: <20080911092156.GA26887@cs181140183.pp.htv.fi>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-2-git-send-email-jwilson@redhat.com> <1220933164-10160-3-git-send-email-jwilson@redhat.com> <1220933164-10160-4-git-send-email-jwilson@redhat.com> <1220933164-10160-5-git-send-email-jwilson@redhat.com> <20080909173057.6d93a7ef@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080909173057.6d93a7ef@bike.lwn.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2008 at 05:30:57PM -0600, Jonathan Corbet wrote:
> On Tue,  9 Sep 2008 00:05:49 -0400
> Jarod Wilson <jwilson@redhat.com> wrote:
> 
> > +/*
> > + * LIRC driver for Philips eHome USB Infrared Transceiver
> > + * and the Microsoft MCE 2005 Remote Control
> > + *
> > + * (C) by Martin A. Blatter <martin_a_blatter@yahoo.com>
> > + *
> > + * Transmitter support and reception code cleanup.
> > + * (C) by Daniel Melander <lirc@rajidae.se>
> 
> As I understand it, proper assertions of copyright need the word
> "copyright" and a year; the "(C)" trigraph doesn't have any legal meaning.
>...

As far as I understand it your statement is only true if you are in
the USA and travel back in time by at least 20 years, and otherwise
no proper assertion is required at all.

Anything I miss?

> jon

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

