Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbYAEXa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbYAEXa6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 18:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbYAEXat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 18:30:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58309 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbYAEXas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 18:30:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gregor Jasny <jasny@vidsoft.de>
Subject: Re: Regression: VIDIOCGMBUF ioctl hangs on bttv driver (2.6.24-rc6)
Date: Sun, 6 Jan 2008 00:32:43 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org,
       video4linux-list <video4linux-list@redhat.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org
References: <20080105223338.GA18690@vidsoft.de>
In-Reply-To: <20080105223338.GA18690@vidsoft.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801060032.43705.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 5 of January 2008, Gregor Jasny wrote:
> Hi,
> 
> During some tests I've noticed that the VIDIOCGMBUF ioctl hangs on my
> bttv video device. It simply does not return and the process is stuck in
> the D+ state. With Kernel 2.6.22.9 the (attached) testcase works like a
> charm. The V4L2 interface is working with 2.6.24, too (at least displays
> xawtv the usual pixel snow).

Do the 2.6.23.x kernels work?

Rafael
