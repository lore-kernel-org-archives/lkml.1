Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbYHGRg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbYHGRg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbYHGRgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:36:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:58325 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYHGRgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:36:17 -0400
Subject: Re: [GIT PULL]: firmware patches for building firmware into kernel
From: Jaswinder Singh <jaswinder@infradead.org>
To: David Dillow <dave@thedillows.org>
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1218130222.18118.7.camel@lap75545.ornl.gov>
References: <1218128219.14483.7.camel@jaswinder.satnam>
	 <1218130222.18118.7.camel@lap75545.ornl.gov>
Content-Type: text/plain; charset=utf8
Date: Thu, 07 Aug 2008 23:04:35 +0530
Message-Id: <1218130475.14483.16.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David Dillow,

On Thu, 2008-08-07 at 13:30 -0400, David Dillow wrote:
> On Thu, 2008-08-07 at 22:26 +0530, Jaswinder Singh wrote:
> >       firmware: avoiding multiple replication for same firmware file
> 
> If this is the last patch you sent to the list, I think there are still
> locking bugs in it. I was short on time, so I didn't give it a full
> review, but I remember seeing problems. I'll try to give it some time
> tonight, if Andrew doesn't beat me to it.
> 

This is updated and revised patch.

> >       typhoon: use request_firmware
> 
> This is untested -- again, no time over the weekend -- and I'd rather
> not have it go upstream until has been verified.
> 
> 

﻿This is also updated and revised patch.

You can check from :
http://git.infradead.org/users/jaswinder/firm-jsr-2.6.git?a=shortlog

Thank you,

Jaswinder Singh.


