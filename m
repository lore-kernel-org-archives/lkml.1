Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbXHERrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbXHERrS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 13:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbXHERrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 13:47:04 -0400
Received: from eazy.amigager.de ([213.239.192.238]:34642 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbXHERrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 13:47:03 -0400
Date: Sun, 5 Aug 2007 19:46:48 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Page Cache Question
Message-ID: <20070805174648.GA30512@thinkpad.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <725937.57185.qm@web33705.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <725937.57185.qm@web33705.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 09:32:59 -0700, Adnan Khaleel wrote:
> 
> I'm looking for a way to disable the page cache for an
> experimental NUMA system running the 2.6.17 kernel. I would prefer to
> only disable the page cache for my process and still have it be enabled
> by the rest of the system. Is there an easy way of doing this?
> Alternatively, I would be fine disabling the Page Cache altogether as well.

Maybe this helps for you:

http://lwn.net/Articles/224653/

Regards,
Tino
