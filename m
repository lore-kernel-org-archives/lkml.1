Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbYI3OSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbYI3OSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 10:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbYI3ORz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 10:17:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:50085 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbYI3ORy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 10:17:54 -0400
Message-ID: <48E234B8.4050009@kernel.org>
Date: Tue, 30 Sep 2008 23:16:24 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Robert Krawitz <rlk@alum.mit.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Another one for fixup-storage
References: <4897809E.8070902@alum.mit.edu> <48E0824B.4010408@kernel.org> <200809291141.m8TBfxiU004269@dsl092-065-009.bos1.dsl.speakeasy.net>
In-Reply-To: <200809291141.m8TBfxiU004269@dsl092-065-009.bos1.dsl.speakeasy.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 30 Sep 2008 14:17:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Krawitz wrote:
>    Date: Mon, 29 Sep 2008 16:22:51 +0900
>    From: Tejun Heo <tj@kernel.org>
> 
>    Robert Krawitz wrote:
>    > This is for a Dell Inspiron E1705/9400.  I'm using a non-OEM disk (a
>    > Hitachi 320 GB drive).
>    > 
>    > Note that matching on "MP061" doesn't work -- it needs to be "MP061*"
>    > due to the way dmidecode seems to return the data (with a bunch of
>    > spaces after the tag).  Hence I've attached the data rather than merely
>    > 
>    > I've only had this thing a month or so and already had over 70,000
>    > unload cycles.  Ick.
> 
>    Can you please attach the result of "smartctl -a" output?
> 
> # smartctl -a /dev/sda
> smartctl 5.39 2008-05-08 21:56 [x86_64-unknown-linux-gnu] (local build)
> Copyright (C) 2002-8 by Bruce Allen, http://smartmontools.sourceforge.net

Thanks.  And how much does the load cycle count increase per hour
without any adustment?

-- 
tejun
