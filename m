Return-Path: <linux-kernel-owner+w=401wt.eu-S1752253AbZLRPnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbZLRPnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbZLRPnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:43:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:43599 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbZLRPnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:43:40 -0500
Subject: Re: spinlock which can morph into a mutex
From: Peter Zijlstra <peterz@infradead.org>
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20091218143032.GA16595@xs4all.net>
References: <20091218143032.GA16595@xs4all.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Dec 2009 16:43:14 +0100
Message-ID: <1261150994.20899.303.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 15:30 +0100, Miquel van Smoorenburg wrote:

> I just convert the spinlocks to mutexes with minimal extra overhead ?

Yep.

