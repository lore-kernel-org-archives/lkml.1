Return-Path: <linux-kernel-owner+w=401wt.eu-S1751948AbZLVKad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbZLVKad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 05:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbZLVKac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 05:30:32 -0500
Received: from mail.gmx.net ([213.165.64.20]:43255 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751614AbZLVKac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 05:30:32 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19o2WhY3YZoid2aX1YYJrj2fQY76hGd54t7JX8lsd
	E+qanuHw50pyzO
From: Peter =?utf-8?q?H=C3=BCwe?= <PeterHuewe@gmx.de>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] MAINTAINERS: Fix entry for uwb to include subdirectories
Date: Tue, 22 Dec 2009 11:30:30 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27-05415-g69a8594; KDE/4.3.3; x86_64; ; )
Cc: David Vrabel <david.vrabel@csr.com>, Jiri Kosina <trivial@kernel.org>,
       kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1261472760-24854-1-git-send-email-peterhuewe@gmx.de> <1261473735.1895.22.camel@Joe-Laptop.home>
In-Reply-To: <1261473735.1895.22.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912221130.30586.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 22 Dezember 2009 10:22:15 schrieb Joe Perches:
> On Tue, 2009-12-22 at 10:05 +0100, Peter Huewe wrote:
> > This little patch removes the asterisk wildcard, in order to get the uwb
> > maintainer when using get_maintainer.pl on anyfiles in the
> > subdirectories of uwb.
> 
> Is this correct?
> Does David Vrabel maintain drivers/uwb/i1480/ ?
> 
> drivers/uwb/wlp/ is separately maintained
> WIMEDIA LLC PROTOCOL (WLP) SUBSYSTEM

Okay I guess it IS correct - if you look at the entries in MAINTAINERS:
both 
drivers/uwb/wlp/  and drivers/uwb/
are infact maintained by David - only the mailing list is missing from the 
second.

ULTRA-WIDEBAND (UWB) SUBSYSTEM:
M:  David Vrabel <david.vrabel@csr.com>
L:  linux-usb@vger.kernel.org
S:  Supported
F:  drivers/uwb/*
F:  include/linux/uwb.h
F:  include/linux/uwb/


WIMEDIA LLC PROTOCOL (WLP) SUBSYSTEM
M:  David Vrabel <david.vrabel@csr.com>
S:  Maintained
F:  include/linux/wlp.h
F:  drivers/uwb/wlp/


