Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbYIIT7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbYIIT7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 15:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbYIIT7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 15:59:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33237 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbYIIT7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 15:59:24 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>, Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 02/18] lirc serial port receiver/transmitter device driver
Date: Tue, 9 Sep 2008 15:56:44 -0400
User-Agent: KMail/1.10.1 (Linux/2.6.25.16-1.fc10.x86_64; KDE/4.1.1; x86_64; ; )
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Christoph Bartelmus <lirc@bartelmus.de>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <20080909101422.329bd351@bike.lwn.net> <200809092151.18332.s.L-H@gmx.de>
In-Reply-To: <200809092151.18332.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091556.44998.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 15:51:12 Stefan Lippers-Hollmann wrote:
> Hi
>
> On Dienstag, 9. September 2008, Jonathan Corbet wrote:
> > > +config LIRC_SERIAL
> > > +	tristate "Homebrew Serial Port Receiver"
> > > +	default n
> > > +	depends on LIRC_DEV
> > > +	help
> > > +	  Driver for Homebrew Serial Port Receivers
> >
> > What receivers might these be?  Do any actually exist?
>
> [...]
>
> This might actually be the most common setup, as it is very easy to
> build[1] with minimal soldering skills and has also been used by various
> vendors (older models of the TechniSat SkyStar2 DVB-S budget card, to name
> just one example; it is only slowly being replaced by alternative means,
> as serial ports are becoming rare on newer systems.
>
> Regards
> 	Stefan Lippers-Hollmann
>
> [1]	http://www.lirc.org/receivers.html

One frequently-used source of pre-built serial receivers (and transmitters) 
here in the US is http://irblaster.info/.

Hey, that actually just reminded me... I think I *do* have a serial IR 
receiver laying about somewhere that came w/one of my TechniSat SkyStar 
HD-5000 cards... Thank you, Stefan! ;)

-- 
Jarod Wilson
jarod@redhat.com

