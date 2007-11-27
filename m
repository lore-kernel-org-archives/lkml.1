Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbXK0Nq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbXK0Nq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 08:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbXK0Nqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 08:46:50 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:2742 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbXK0Nqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 08:46:49 -0500
Date: Tue, 27 Nov 2007 14:46:45 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>, Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: can support for "rpm"-based package building just be dropped?
Message-ID: <20071127134645.GB20000@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	"Robert P. J. Day" <rpjday@crashcourse.ca>,
	Ray Lee <ray-lk@madrabbit.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.9999.0711260352060.30676@localhost.localdomain> <2c0942db0711260658j5ce017e7ucce4c373748ed7b7@mail.gmail.com> <Pine.LNX.4.64.0711261622060.19299@fbirervta.pbzchgretzou.qr> <alpine.LFD.0.9999.0711261048050.24142@localhost.localdomain> <Pine.LNX.4.64.0711261704070.19299@fbirervta.pbzchgretzou.qr> <alpine.LFD.0.9999.0711261110040.25316@localhost.localdomain> <Pine.LNX.4.64.0711261716220.22369@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711261716220.22369@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 05:17:18PM +0100, Jan Engelhardt wrote:
> rpm -b does not work in opensuse anymore (redirects you to use rpmbuild), and I
> bet fedora will do the same, so if you don't have rpm-build, tough luck for
> make rpm.

The point, if I understand it correctly, was that when rpmbuild is not
install and rpm is not building-capable not to fall back to rpm and
instead yell loudly that rpmbuild is missing.

To which some said that right now "do not fall back, ever, just
require rpmbuild" may just be the best.

I have no opinion though.

  OG.

