Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbYDNJ12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbYDNJ12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 05:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbYDNJ1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 05:27:18 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:17485 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbYDNJ1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 05:27:17 -0400
To: sclark46@earthlink.net
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       Tilman Schmidt <tilman@imap.cc>, Valdis.Kletnieks@vt.edu,
       Mark Lord <lkml@rtr.ca>, David Miller <davem@davemloft.net>,
       jesper.juhl@gmail.com, yoshfuji@linux-ipv6.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Reporting bugs and bisection
From: Andi Kleen <andi@firstfloor.org>
References: <47FEADCB.7070104@rtr.ca>
	<20080413121831.d89dd424.akpm@linux-foundation.org>
	<20080413202118.GA29658@2ka.mipt.ru> <200804132233.50491.rjw@sisk.pl>
	<20080413205406.GA9190@2ka.mipt.ru> <48028830.6020703@earthlink.net>
Date: Mon, 14 Apr 2008 11:26:24 +0200
In-Reply-To: <48028830.6020703@earthlink.net> (Stephen Clark's message of "Sun, 13 Apr 2008 18:24:48 -0400")
Message-ID: <87d4oswzwf.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Apr 2008 09:19:38.0970 (UTC) FILETIME=[AA0CF3A0:01C89E10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Clark <sclark46@earthlink.net> writes:

> I been a linux user and have followed the LKML for a
> number of years and have yet to see
> any test plans for any submitted patches.

You haven't looked closely then. While it's not very common there 
is a non trivial number of patches who describe how they got tested
in the patch description.

-Andi
