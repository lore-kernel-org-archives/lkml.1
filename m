Return-Path: <linux-kernel-owner+w=401wt.eu-S1751959AbXAXPNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbXAXPNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 10:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbXAXPNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 10:13:50 -0500
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:41653 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbXAXPNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 10:13:49 -0500
Message-ID: <45B777AC.9050709@s5r6.in-berlin.de>
Date: Wed, 24 Jan 2007 16:13:48 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.0.8) Gecko/20061030 SeaMonkey/1.0.6
MIME-Version: 1.0
To: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@bitplanet.net>
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: In-tree version of new FireWire drivers available
References: <59ad55d30701231948u5f1e02d8x3d06553cb373e5be@mail.gmail.com>
In-Reply-To: <59ad55d30701231948u5f1e02d8x3d06553cb373e5be@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristian Høgsberg wrote:
> Hosting this on freedesktop.org should be fine,
> though kernel.org may be more appropriate :)

At the moment, a host outside of kernel.org is actually better for
gitweb lurkers. (But I trust that kernel.org will get up to speed again
soon.)

> Stefan, I'm still not sure what the work flow should be
> here, do you want to just pull these changes or should I send the 13
> patches to linux1394-devel?

IMO: Posting patches to linux1394-devel is a must for anything that is
meant to go to -mm or ultimately to mainline. In some cases, patches
should also be Cc'd to linux-kernel or specialized lists like linux-scsi
or linuxppc-dev etc. depending on the issue. I think linux1394-devel can
bear the additional traffic from this new development.

The question is whether you will post what you wrote, or if I will post
what I pulled from you...
-- 
Stefan Richter
-=====-=-=== ---= ==---
http://arcgraph.de/sr/
