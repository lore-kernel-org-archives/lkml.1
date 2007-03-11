Return-Path: <linux-kernel-owner+w=401wt.eu-S933595AbXCKWzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933595AbXCKWzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 18:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933608AbXCKWzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 18:55:49 -0400
Received: from mail26.syd.optusnet.com.au ([211.29.133.167]:42035 "EHLO
	mail26.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933595AbXCKWzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 18:55:48 -0400
From: Con Kolivas <kernel@kolivas.org>
To: bert hubert <bert.hubert@netherlabs.nl>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Date: Mon, 12 Mar 2007 09:57:01 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070311222945.GA8242@outpost.ds9a.nl>
In-Reply-To: <20070311222945.GA8242@outpost.ds9a.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703120957.01315.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007 09:29, bert hubert wrote:
> Con,
>
> Recent kernel versions have real problems for me on the interactivity
> front, with even a simple 'make' of my C++ program (PowerDNS) causing
> Firefox to slow down to a crawl.
>
> RSDL fixed all that, the system is noticeably snappier.
>
> As a case in point, I used to notice when a compile was done because the
> system stopped being sluggish.
>
> Today, a few times, I only noticed 'make' was done because the fans of my
> computer slowed down.
>
> Thanks for the good work! I'm on 2.6.21-rc3-rsdl-0.29.

You're most welcome, and thank you for the report :)

> 	Bert

-- 
-ck
