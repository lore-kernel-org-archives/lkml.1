Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbZEPPVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbZEPPVd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 11:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbZEPPVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 11:21:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:32062 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbZEPPVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 11:21:24 -0400
Date: Sat, 16 May 2009 20:21:20 +0500
From: Constantin Baranov <const@mimas.ru>
To: Tobias_Mueller@twam.info
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH 001/001] leds: alix-leds2 fixed for Award BIOS
Message-Id: <20090516202120.95e79b53.const@mimas.ru>
In-Reply-To: <17be05570905160252l3ffc1923xf5031702947948a6@mail.gmail.com>
References: <17be05570905130710s1192729cqafa09127f6c34bf9@mail.gmail.com>
	<20090513151415.6e84fd82.akpm@linux-foundation.org>
	<17be05570905140208n5fd695aayfad221808f70ac21@mail.gmail.com>
	<20090515010947.4016ba66.const@mimas.ru>
	<17be05570905141323l31ee6f9o71698e57aec4b698@mail.gmail.com>
	<20090515023202.57387cb2.const@mimas.ru>
	<17be05570905160252l3ffc1923xf5031702947948a6@mail.gmail.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 May 2009 11:52:35 +0200 Tobias Müller <Tobias_Mueller@twam.info> wrote:
> 2009/5/14 Constantin Baranov <const@mimas.ru>:
> > OK, 'double' initialization seems good.
> > I will test it on my ALIX.2c3 later.
> Did you get some results>
Yes, I have not found any effect of those three outls on ALIX.2c3.
Thus I consider the patch to be safe.

Reviewed-by: Constantin Baranov <const@mimas.ru>
