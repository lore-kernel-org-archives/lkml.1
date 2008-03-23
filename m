Return-Path: <linux-kernel-owner+w=401wt.eu-S1758923AbYCWTCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923AbYCWTCJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 15:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755082AbYCWTB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 15:01:56 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:35425 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578AbYCWTBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 15:01:55 -0400
Date: Sun, 23 Mar 2008 20:01:48 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
In-Reply-To: <200803170018.52663.rjw@sisk.pl>
Message-ID: <alpine.DEB.1.00.0803231955530.13579@sheep.housecafe.de>
References: <200803170018.52663.rjw@sisk.pl>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Mon, 17 Mar 2008, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10207
> Subject		: INFO: task mount:11202 blocked for more than 120 seconds
> Submitter	: Christian Kujau <lists@nerdbynature.de>
> Date		: 2008-03-07 21:32 (10 days old)
> References	: http://lkml.org/lkml/2008/3/7/308
> 		  http://lkml.org/lkml/2008/3/9/186
>

The other Christian reported this as fixed: http://lkml.org/lkml/2008/3/17/232
I too can confirm that the hangs are gone now: http://lkml.org/lkml/2008/3/21/532

Thanks for maintaining the regression list,
Christian.
-- 
BOFH excuse #91:

Mouse chewed through power cable
