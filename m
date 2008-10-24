Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbYJXWjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbYJXWjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 18:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbYJXWjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 18:39:05 -0400
Received: from yergi.telenet-ops.be ([195.130.132.36]:39309 "EHLO
	yergi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbYJXWjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 18:39:04 -0400
Subject: Re: 2.6.27: add patch for ALPS touchpad on Latitude E6[45]00
From: Frederik Himpe <fhimpe@telenet.be>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200810250026.50026.rjw@sisk.pl>
References: <pan.2008.10.11.15.33.28@telenet.be>
	 <200810250026.50026.rjw@sisk.pl>
Content-Type: text/plain
Date: Sat, 25 Oct 2008 00:37:59 +0200
Message-Id: <1224887879.4526.3.camel@Anastacia.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0-2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On za, 2008-10-25 at 00:26 +0200, Rafael J. Wysocki wrote:
> On Saturday, 11 of October 2008, Frederik Himpe wrote:
> > I need to add this patch to the 2.6.27 kernel to have my touchpad detected 
> > correctly on my Latitude E6400 laptop. Is it possible to apply this to 
> > 2.6.27 stable?
> > 
> > http://lkml.org/lkml/2008/9/7/133
> 
> Did 2.6.26 work for you correctly without this patch?

I have this machine only for a few weeks and immediately used 2.6.27-rc,
but I see no reason why it would work in 2.6.26. Note that the touchpad
itself works, however it is not recognised by the synaptics driver,
making it impossible to use any of the advanced features such as
tap-to-click and scrolling.

At least Mandriva 2009.0 and Ubuntu 8.10 include this patch in their
kernels.

-- 
Frederik Himpe <fhimpe@telenet.be>

