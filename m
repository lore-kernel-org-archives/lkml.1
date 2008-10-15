Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbYJOOfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbYJOOfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbYJOOe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:34:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:52612 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbYJOOe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:34:57 -0400
Subject: Re: [QUESTION] Where can I get lockstat/lockdep userspace tools
From: Peter Zijlstra <peterz@infradead.org>
To: Niraj kumar <niraj17@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <b82a89170810150720p2d5ab5efnd6c5ef0bdbd1a03d@mail.gmail.com>
References: <b82a89170810150720p2d5ab5efnd6c5ef0bdbd1a03d@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 15 Oct 2008 16:35:02 +0200
Message-Id: <1224081302.28131.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-15 at 19:50 +0530, Niraj kumar wrote:
> Hi,
> 
> Can anybody tell me where I can get the userspace tools (similar to
> what Solaris has) for working with lockstat/lockdep feature in kernel.

cat, grep, awk has always been plenty powerful to work with the
various /proc files provided by lockdep/lockstat.

Not knowing anything about solaris, nor really caring about it, I'm
afraid you have to be more specific about that you want.


