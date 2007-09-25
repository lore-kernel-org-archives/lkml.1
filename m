Return-Path: <linux-kernel-owner+w=401wt.eu-S1759558AbXIYPt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558AbXIYPt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 11:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbXIYPtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 11:49:21 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:28537 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107AbXIYPtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 11:49:20 -0400
Date: Tue, 25 Sep 2007 08:48:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mihai =?UTF-8?Q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Cc: "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc7 + radeonfb/s2ram
Message-Id: <20070925084810.3196da8c.randy.dunlap@oracle.com>
In-Reply-To: <200709251009.30081.mihai.dontu@gmail.com>
References: <200709220828.00078.mihai.dontu@gmail.com>
	<20070924144344.GA14022@alberich.amd.com>
	<200709251009.30081.mihai.dontu@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 10:09:29 +0300 Mihai Donțu wrote:

> On Monday 24 September 2007, Andreas Herrmann wrote:
> > Have you tried to boot your kernel with
> > 
> >    video=radeonfb:noaccel
> > 
> > I usual add this kernel parameter when running radeonfb and X.
> > 
> > Otherwise I've observed the same symptoms (e.g. with my radeon card
> > at home: Radeon X300SE, 1002:5b70).
> 
> It works. Golden option. Should be documented somewhere.

Looks like radeonfb needs a radeonfb.txt file in
Documentation/fb/.  There is a txt file for aty128fb which does
include this option and others...


---
~Randy
Phaedrus says that Quality is about caring.
