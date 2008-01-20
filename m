Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbYATUOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbYATUOr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 15:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbYATUOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 15:14:36 -0500
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:42434 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754734AbYATUOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 15:14:35 -0500
To: Andi Kleen <ak@suse.de>
Subject: Re: 2.6.24 regression: reference count leak in PPPoE
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-reply-To: <200801202053.30386.ak@suse.de>
References: <200801202053.30386.ak@suse.de>
Message-Id: <E1JGgYq-0005Rd-2x@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Sun, 20 Jan 2008 21:14:32 +0100
X-OriginalArrivalTime: 20 Jan 2008 20:14:32.0482 (UTC) FILETIME=[11B25020:01C85BA1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> My workstation running 2.6.24-rc8 just hung during shutdown with an
> endless (or rather I didn't wait more than a few minutes) loop of
> 
> unregister_netdev: waiting for ppp-device to become free. Usage count = 1

Same as http://lkml.org/lkml/2008/1/20/27? See also follow-up to that.

Cheers,
FJP
