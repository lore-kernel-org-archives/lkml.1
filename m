Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbYDUMY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbYDUMY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 08:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755987AbYDUMYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 08:24:14 -0400
Received: from stinky.trash.net ([213.144.137.162]:39005 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbYDUMYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 08:24:13 -0400
Message-ID: <480C8766.9010802@trash.net>
Date: Mon, 21 Apr 2008 14:24:06 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: Roel Kluin <12o3l@tiscali.nl>
CC: Jan Engelhardt <jengelh@computergmbh.de>, coreteam@netfilter.org,
       netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [netfilter-core] [PATCH 5/6] NETFILTER: signed tcphoff for	ipv6_skip_exthdr()
 retval
References: <480558CA.7090800@tiscali.nl> <48062282.4070204@tiscali.nl>
In-Reply-To: <48062282.4070204@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> if tcphoff remains unsigned, a negative ipv6_skip_exthdr() return value will
> go unnoticed,

Applied, thanks.
