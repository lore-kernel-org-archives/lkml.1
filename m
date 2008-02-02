Return-Path: <linux-kernel-owner+w=401wt.eu-S1763671AbYBBQHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763671AbYBBQHx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 11:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbYBBQHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 11:07:46 -0500
Received: from hpsmtp-eml15.kpnxchange.com ([213.75.38.115]:59503 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708AbYBBQHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 11:07:45 -0500
To: Peter Teoh <htmldeveloper@gmail.com>
Subject: Re: Incompatibility of "const" and __xxxinitdata?
Cc: linux-kernel@vger.kernel.org
In-reply-To: <804dabb00802020720p2684dd1eyc29d1e1410407e08@mail.gmail.com>
References: <804dabb00802020720p2684dd1eyc29d1e1410407e08@mail.gmail.com>
Message-Id: <E1JLKu5-0002b0-Gb@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Sat, 02 Feb 2008 17:07:41 +0100
X-OriginalArrivalTime: 02 Feb 2008 16:07:44.0025 (UTC) FILETIME=[BE89D890:01C865B5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Teoh wrote:
> In include/linux/init.h, it is documented that all __xxxinitdata
> declaration must not have constant, as show below:

See: http://lkml.org/lkml/2008/1/26/182

There's a fairly major cleanup happening at the moment as you could see from
the mailing list archives for the past week or so.

Cheers,
FJP
