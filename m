Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbYGXSaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbYGXSaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 14:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYGXSaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 14:30:07 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:34088 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752072AbYGXSaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 14:30:06 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: how much stuff is no longer "EXPERIMENTAL"?
Date: Fri, 25 Jul 2008 04:29:45 +1000
Organization: http://bugsplatter.mine.nu/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <h2ih845fmasm3coi3qapmqkknj0ghp6k7t@4ax.com>
References: <alpine.LFD.1.10.0807241114000.4119@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.10.0807241114000.4119@localhost.localdomain>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2008 11:14:22 -0400 (EDT), "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:

>
>  how about a concerted effort to remove inappropriate EXPERIMENTAL
>dependencies from the Kconfig files?  there must be a truckload of
>stuff that has long since matured beyond EXPERIMENTAL status that is
>still tagged that way.

I sent a patch to remove EXPERIMENTAL on a three year old driver couple 
months ago, it got Acked by maintainer, hwmon/adm9240.  But I dunno if 
the patch is queued somewhere or lost.

Grant.
