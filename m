Return-Path: <linux-kernel-owner+w=401wt.eu-S1757501AbXFSGNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbXFSGNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 02:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbXFSGND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 02:13:03 -0400
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:40114 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753947AbXFSGNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 02:13:02 -0400
Date: Tue, 19 Jun 2007 08:13:00 +0200
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: GIT Packages for Debian Etch
Message-ID: <20070619061300.GK16393@cip.informatik.uni-erlangen.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	Christoph Lameter <clameter@sgi.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <20070618212524.GC16393@cip.informatik.uni-erlangen.de> <Pine.LNX.4.64.0706181617060.18601@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706181617060.18601@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.15 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo,

> Is there some way you can feed that into Debian please? Why the go
> around through a separate repository? The maintainer of git-core is
> not actively maintaining the package?

it already is. But Debian Etch is stable which means there will no newer
version of git in Debian Etch. Currently it is 1.4.whatever. When the
next stable release is released, which takes some time with Debian,
there will be a newer version of git shipped with it. So for the moment
you have to a few choices to live with when you use Debian stable:

        - Use the old git version 1.4
        - Build a newer version yourself
        - Use the backports or any other prebuild but up2date packages

For me it was unacceptable to use git version 1.4 since the pacing of
git is very fast. So I follow the stable releases of git very close. And
as a result I update all my personal machines, the all the machines at
university and the machines I use at work with a recent git version.

        Thomas
