Return-Path: <linux-kernel-owner+w=401wt.eu-S932607AbYBTPas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607AbYBTPas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765836AbYBTPZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:25:40 -0500
Received: from hpsmtp-eml17.KPNXCHANGE.COM ([213.75.38.117]:4502 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765821AbYBTPZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:25:39 -0500
To: Karl Dahlke <eklhad@comcast.net>
Subject: Re: adapter, what's in a name
Cc: jengelh@computergmbh.de, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, sam@ravnborg.org, Valdis.Kletnieks@vt.edu
In-reply-To: <20080120093744.eklhad@comcast.net>
References: <20080120093744.eklhad@comcast.net>
Message-Id: <E1JRqpC-0002Va-Mo@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Wed, 20 Feb 2008 16:25:34 +0100
X-OriginalArrivalTime: 20 Feb 2008 15:25:37.0300 (UTC) FILETIME=[D7EDB540:01C873D4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karl Dahlke wrote:
> Meantime, I pulled the emails out of the headers and pasted them in.
> Hope that reasonably works.

Well, you're still breaking the thread by starting a new one.

Guess when you're implementing reply-to-all, you should also think about
implementing support for In-Reply-To: and References: headers (and possibly
a whole lot of other stuff that's supposed to be included in a
standards-compliant MUA).

Cheers,
FJP
