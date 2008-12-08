Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbYLHXmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbYLHXmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 18:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbYLHXm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 18:42:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753452AbYLHXm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 18:42:29 -0500
Date: Mon, 8 Dec 2008 15:41:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: bcasavan@sgi.com, linux-kernel@vger.kernel.org, mdr@sgi.com, rw@novell.com,
       greg@kroah.com
Subject: Re: [PATCH] ioc4: automatically load sgiioc4 subordinate module
Message-Id: <20081208154155.1a4dd7ae.akpm@linux-foundation.org>
In-Reply-To: <1228779363.5099.41.camel@nga>
References: <alpine.BSF.1.10.0812051601060.388@pkunk.americas.sgi.com>
	<20081208145507.8d03834e.akpm@linux-foundation.org>
	<1228779363.5099.41.camel@nga>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Dec 2008 00:36:03 +0100
Kay Sievers <kay.sievers@vrfy.org> wrote:

> > This is a fairly common problem, isn't it?
> 
> [ ... ]

Useful, thanks.


Brent, please take a look at the schedule_work() race for v2 and we'll
do it that way.


