Return-Path: <linux-kernel-owner+w=401wt.eu-S1762363AbXK2LV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762363AbXK2LV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 06:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbXK2LVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 06:21:20 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57211 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754684AbXK2LVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 06:21:19 -0500
Date: Thu, 29 Nov 2007 03:20:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, trivial@kernel.org
Subject: Re: Trailing periods in kernel messages (was: [PATCH 6/6] tick: add
 a missing dot in prink)
Message-Id: <20071129032036.4c021617.akpm@linux-foundation.org>
In-Reply-To: <200711291120.19595.elendil@planet.nl>
References: <474E6BD0.20103@cn.fujitsu.com>
	<E1IxfE8-0000Sr-9w@faramir.fjphome.nl>
	<474E8669.6060409@cn.fujitsu.com>
	<200711291120.19595.elendil@planet.nl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 11:20:18 +0100 Frans Pop <elendil@planet.nl> wrote:

> Well, for one it needlessly increases the size of log files.
> It also IMO just looks weird to have a trailing period only for some 
> messages and it certainly is completely inappropriate for messages like:

I'll confess to stealthily deleting some of those periods when nobody is looking.
I don't find them to have any value and they do have some cost, including screen
real estate at the source-code level.
