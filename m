Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbYDFUbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbYDFUbZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 16:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYDFUbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 16:31:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50385 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbYDFUbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 16:31:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: suspend issue
Date: Sun, 6 Apr 2008 22:31:26 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Soeren Sonnenburg" <kernel@nn7.de>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>
References: <dd18b0c30804052103s7357bb86yf7bf11d38d2911b3@mail.gmail.com> <1207490104.4597.36.camel@localhost> <dd18b0c30804060848r44b0370am2bd20e0738ab16f4@mail.gmail.com>
In-Reply-To: <dd18b0c30804060848r44b0370am2bd20e0738ab16f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804062231.27282.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 6 of April 2008, Justin Mattock wrote:
> Yeah; that's what I was contemplating as well.

Dave, has anything changed in the video/graphics department that might
cause that to happen?

Rafael

 
> On Sun, Apr 6, 2008 at 1:55 PM, Soeren Sonnenburg <kernel@nn7.de> wrote:
> >
> > On Sun, 2008-04-06 at 04:03 +0000, Justin Mattock wrote:
> >  > Hello; I seem to have discovered something with echo mem > /sys/power/state.
> >  > I recompile the kernel and had forgotten to compile fglrx, when
> >  > performing a suspend without fglrx I was confronted with the dreaded
> >  > blank screen and a reboot. then as a test I compiled fglrx and loaded,
> >  > and to my amazement suspend reacted properly again.
> >
> >  Yeah, but I it does not even work without X - console only!
> >
> >  s2ram -f -p used to work since at least 2.6.20 ... and is now not
> >  anymore in 2.6.25-*
> >
> >  Soeren
