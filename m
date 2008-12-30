Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbYL3DC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbYL3DC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 22:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYL3DCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 22:02:19 -0500
Received: from rv-out-0506.google.com ([209.85.198.227]:48536 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbYL3DCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 22:02:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jl3ysV43zORlf+hpT7m4ATDjxI7oceyKiBc7UAdNy1W0edJRo5Mf6u6sH9aAD4wIW5
         P936uVpZvrT0MUoBlV4NXTtWVYL+hTmWw9b9bc/mHm6ibVTGgPV0oU0XAQcprLJG0C+q
         htziNAIO6lvuSrABxDS6s5XHw1Zd7yRP69XCA=
Message-ID: <3f9a31f40812291902r3839228dg191ec1dec7a49aa9@mail.gmail.com>
Date: Tue, 30 Dec 2008 08:32:17 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Ben Hutchings" <ben@decadent.org.uk>
Subject: Re: [PATCH] radeon_cp: use request_firmware
Cc: "Julien Cristau" <jcristau@debian.org>, "Dave Airlie" <airlied@linux.ie>,
       "Jaswinder Singh" <jaswinder@infradead.org>,
       dri-devel@lists.sourceforge.net,
       "David Woodhouse" <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1230044014.3402.6.camel@deadeye.i.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218095497.4016.3.camel@jaswinder.satnam>
	 <3f9a31f40812191223g72b8a1eey2780f8e1a0ebf7aa@mail.gmail.com>
	 <alpine.DEB.2.00.0812212056060.8861@skynet.skynet.ie>
	 <20081222103913.GF10379@patate.is-a-geek.org>
	 <1230044014.3402.6.camel@deadeye.i.decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ben, Dave,

On Tue, Dec 23, 2008 at 8:23 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
> I had to revise Jaswinder's patch as it allowed a double-free.  I'm
> attaching the version I've tested (which is against v2.6.26 so the paths
> are different).  That was tested on a Radeon Mobility 7500 (R100 if I
> remember correctly).

What is next step.

Thank you,
JSR
