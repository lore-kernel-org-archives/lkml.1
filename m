Return-Path: <linux-kernel-owner+w=401wt.eu-S1767374AbXECE1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767374AbXECE1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 00:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767377AbXECE1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 00:27:34 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767374AbXECE1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 00:27:34 -0400
Date: Wed, 2 May 2007 21:27:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] rename thread_info to stack
Message-Id: <20070502212721.5883abbc.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705010210010.1479@scrub.home>
References: <Pine.LNX.4.64.0705010210010.1479@scrub.home>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007 02:10:34 +0200 (CEST) Roman Zippel <zippel@linux-m68k.org> wrote:

> This finally renames the thread_info field in task structure to stack,
> so that the assumptions about this field are gone and archs have more
> freedom about placing the thread_info structure.

It's been a year or so and I've forgotten what the actual point to these
changes is.  Can we be reminded please?

