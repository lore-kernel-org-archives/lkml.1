Return-Path: <linux-kernel-owner+w=401wt.eu-S1757338AbYASLDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbYASLDx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 06:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbYASLDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 06:03:45 -0500
Received: from hpsmtp-eml19.kpnxchange.com ([213.75.38.84]:6125 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753604AbYASLDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 06:03:44 -0500
To: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: pnpacpi : exceeded the max number of IO resources
Cc: akpm@osdl.org, bjorn.helgaas@hp.com, cholvenstot@comcast.net,
       elendil@planet.nl, lenb@kernel.org, linux-kernel@vger.kernel.org,
       rene.herman@keyaccess.nl, shaohua.li@intel.com, trenn@suse.de,
       yakui.zhao@intel.com
In-reply-To: <a8e1da0801152155x18cfd0dcvfe638323275e539d@mail.gmail.com>
References: <1196428488.7066.6.camel@localhost> <47508D3C.9050507@keyaccess.nl> <475436A3.90906@keyaccess.nl> <200801082250.51026.lenb@kernel.org> <E1JCXK5-0002GH-0x@faramir.fjphome.nl> <4784DE94.8020508@keyaccess.nl> <a8e1da0801152155x18cfd0dcvfe638323275e539d@mail.gmail.com>
Message-Id: <E1JGBUB-0003HA-1e@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Sat, 19 Jan 2008 12:03:39 +0100
X-OriginalArrivalTime: 19 Jan 2008 11:03:41.0184 (UTC) FILETIME=[F32CB800:01C85A8A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young wrote:
> I noticed the port number changed to 40 in 2.6.24-rc8, but it's not
> enough for me still.

Same here, though the extreme noise has gone.
>From /proc/ioports and dmesg it looks like I'm short by either 1, or 3 :-(

Cheers,
FJP
