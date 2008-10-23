Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbYJWJa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbYJWJa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 05:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbYJWJaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 05:30:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36782 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751601AbYJWJaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 05:30:13 -0400
Date: Thu, 23 Oct 2008 10:29:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Markus Rechberger <mrechberger@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>, acano@fastmail.fm,
       Andre Kelmanson <akelmanson@gmail.com>,
       Bouwsma Barry <freebeer.bouwsma@gmail.com>,
       Dan Kreiser <kreiser@informatik.hu-berlin.de>,
       Frank Neuber <fn@kernelport.de>,
       Jelle de Jong <jelledejong@powercraft.nl>,
       John Stowers <john.stowers.lists@gmail.com>,
       Lukas Kuna <lukas.kuna@evkanet.net>,
       Stefan Vonolfen <stefan.vonolfen@gmail.com>,
       Stephan Berberig <s.berberig@arcor.de>,
       Thomas Giesecke <thomas.giesecke@ibgmbh-naumburg.de>,
       Vitaly Wool <vwool@ru.mvista.com>, Zhenyu Wang <zhen78@gmail.com>
Subject: Re: [PATCH 1/7] Adding empia base driver
Message-ID: <20081023102901.59c14cf6@lxorguk.ukuu.org.uk>
In-Reply-To: <20081022220903.GA15278@kroah.com>
References: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com>
	<20081022220903.GA15278@kroah.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is going to cause a big problem for distros as they will not know
> which to enable, so they will probably just disable this one, which is
> what I don't think you want to have happen :(

Before looking into any of this talk to the V4L and DVB maintainers,
browse video4linux list and have a happy read of stuff like:

http://thread.gmane.org/gmane.linux.drivers.dvb/35454


Now I wonder why Markus didn't cc Mauro on this despite Mauro being
maintainer.

Alan
