Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbZDWKP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbZDWKP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 06:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbZDWKPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 06:15:08 -0400
Received: from mailout11.t-online.de ([194.25.134.85]:41142 "EHLO
	mailout11.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbZDWKPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 06:15:07 -0400
From: Karsten Keil <karsten-keil@t-online.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 3/3] Add reference to CAPI 2.0 standard
Date: Thu, 23 Apr 2009 12:14:14 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.27.19-3.2-default; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       tilman@imap.cc, isdn4linux@listserv.isdn4linux.de,
       i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org
References: <cover.1240410708.git.keil@b1-systems.de> <f094d823a0fc52e010f99aec720c9144d454c2fa.1240410708.git.keil@b1-systems.de> <20090422173232.ad2b3f49.rdunlap@xenotime.net>
In-Reply-To: <20090422173232.ad2b3f49.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904231214.16260.karsten-keil@t-online.de>
X-ID: Tl0XrUZTQh4LRGWt87t33M6bQYKx8j5h158QQotAnykxjPOXSMDUSaeny2OFo9wwBI
X-TOI-MSGID: 4c65f37b-f21d-4ad3-8713-749724a96388
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Donnerstag, 23. April 2009 02:32:32 Randy Dunlap wrote:
> On Wed, 22 Apr 2009 16:31:48 +0200 Karsten Keil wrote:
> > Move the entry about CAPI 2.0 to the beginning and add a URL.
> > Incorporate changes suggested by Randy Dunlap, thanks for proofreading.
> >
> > Signed-off-by: Karsten Keil <keil@b1-systems.de>
> > ---
> >  Documentation/isdn/INTERFACE.CAPI |   20 +++++++++++++-------
> >  1 files changed, 13 insertions(+), 7 deletions(-)
> >
> > diff --git a/Documentation/isdn/INTERFACE.CAPI
> > b/Documentation/isdn/INTERFACE.CAPI index 8947ffc..4d802ee 100644
> > --- a/Documentation/isdn/INTERFACE.CAPI
> > +++ b/Documentation/isdn/INTERFACE.CAPI
> > @@ -3,6 +3,11 @@ Kernel CAPI Interface to Hardware Drivers
> >
> >  1. Overview
> >
> > +From the CAPI 2.0 spezification:
>
>                      ~~~~~~~~~~~~~
>
> typo or language?    specification:

Ouch :-(, never add a single line without spell checking.
Will send out a new set, also fix the wrong From: line in the patches from 
Tilman.

...

