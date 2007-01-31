Return-Path: <linux-kernel-owner+w=401wt.eu-S1030478AbXAaSHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030478AbXAaSHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 13:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030477AbXAaSHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 13:07:48 -0500
Received: from vms048pub.verizon.net ([206.46.252.48]:48658 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030475AbXAaSHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 13:07:48 -0500
Date: Wed, 31 Jan 2007 13:06:53 -0500
From: David Hollis <dhollis@davehollis.com>
Subject: Re: Unidentified Intel wifi network card
In-reply-to: <1170264624.5569.15.camel@scott-640m>
To: wsl3@lrsehosting.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, alan@redhat.com
Message-id: <1170266813.3749.4.camel@dhollis-lnx.sunera.com>
MIME-version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6)
Content-type: text/plain
Content-transfer-encoding: 7bit
References: <1170264624.5569.15.camel@scott-640m>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 11:30 -0600, Scott Lockwood wrote:
> I'm looking for assistance with a wifi device I can't find a driver for,
> the Intel Wireless 3945.
> 
> I"m getting this:
> 
> 0000:0c:00.0 Network controller: Intel Corporation: Unknown device 4222
> (rev 02)
> 
> on a new Dell Latitude D820. Anyone know if there will be an open source
> driver for this any time soon, or if there is one now?
> 
> I'm using the latest vendor supplied kernel, so my apologies if this has
> already been done and I'm late to the party. I wasn't able to find much,
> other than 'use the NDIS wrapper' which I really don't want to do.

http://ipw3945.sf.net
http://ieee80211.sf.net

-- 
David Hollis <dhollis@davehollis.com>

