Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbZJYN6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbZJYN6G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 09:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbZJYN6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 09:58:05 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:61593 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753511AbZJYN6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 09:58:04 -0400
From: Frans Pop <elendil@planet.nl>
To: Paul Rolland <rol@as2917.net>
Subject: Re: Intel Video : screen is "flickering"
Date: Sun, 25 Oct 2009 14:58:05 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, rol@as2917.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <20091025140208.35ed1476@tux.DEF.witbe.net>
In-reply-To: <20091025140208.35ed1476@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910251458.06543.elendil@planet.nl>
X-OriginalArrivalTime: 25 Oct 2009 13:58:06.0953 (UTC) FILETIME=[2DB31590:01CA557B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Rolland wrote:
> I'm running a 2.6.32-rc5 kernel, and I'm facing a flickering screen with
> X (running KDE 4.3 and compiz)...
> It's not always, but I can't find why it starts and why it stops.
> Some logs/traces/informations are below.
> 
> Is this a known issue ? Is there anything I can test to debug or to fix
> this problem ?

This looks like the same problem reported in 
http://lkml.org/lkml/2009/10/2/426.

Could you try the patches in http://lkml.org/lkml/2009/10/18/142?

Cheers,
FJP
