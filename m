Return-Path: <linux-kernel-owner+w=401wt.eu-S933612AbYBBTMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612AbYBBTMT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 14:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757415AbYBBTML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 14:12:11 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60359 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757223AbYBBTMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 14:12:10 -0500
Date: Sat, 2 Feb 2008 11:12:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: cbou@mail.ru
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
Subject: Re: gpiolib merge plans?
Message-Id: <20080202111214.8399b753.akpm@linux-foundation.org>
In-Reply-To: <20080202112645.GA11453@zarina>
References: <20080202112645.GA11453@zarina>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Feb 2008 14:26:45 +0300 Anton Vorontsov <cbou@mail.ru> wrote:

> Hello Andrew, David,
> 
> I wonder what are the merge plans for gpiolib for 2.6.25? Are
> there any design issues that suppress merging?..
> 

I'll merge it all.

> 
> p.s. Sorry if I'm rubbing salt into the wound... but what
> happened to "-mm merge plans" emails?

I haven't got onto it, partly due to uncertainty about how bad 2.6.25 is
looking, partly because of how few 2.6.24-rcX-mmY releases there were,
partly because of how few people bothered testing those releases (case
study: did you?  If not why not?  Serious question.).

Sigh.  I'll take a look at doing it this afternoon.
