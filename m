Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbXKEUIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbXKEUIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 15:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbXKEUIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 15:08:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47777 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbXKEUIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 15:08:47 -0500
Subject: Re: 2.6.24-rc1-git11: Reported regressions from 2.6.23
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Sesterhenn <snakebyte@gmx.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200711021843.25543.rjw@sisk.pl>
References: <200711021843.25543.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 05 Nov 2007 21:08:41 +0100
Message-Id: <1194293321.6544.2.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-02 at 18:43 +0100, Rafael J. Wysocki wrote:

> Subject		: oops in enqueue_entity with 2.6.24-rc1-g54866f03
> Submitter	: Eric Sesterhenn <snakebyte@gmx.de>
> References	: http://lkml.org/lkml/2007/11/2/58
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9285
> Handled-By	: 
> Patch		: 
> 

Can't be reproduced with a fresh build of the same git commit.


