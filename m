Return-Path: <linux-kernel-owner+w=401wt.eu-S1762671AbXEYUwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762671AbXEYUwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 16:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbXEYUvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 16:51:54 -0400
Received: from smtp111.iad.emailsrvr.com ([207.97.245.111]:50340 "EHLO
	smtp111.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbXEYUvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 16:51:53 -0400
Message-ID: <46574C1C.2020508@gentoo.org>
Date: Fri, 25 May 2007 16:50:36 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Matheus Izvekov <mizvekov@izvekov.dyndns.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.21] BUG: at fs/inotify.c:172 set_dentry_child_flags()
References: <20070525200413.GA29664@izvekov.dyndns.org>
In-Reply-To: <20070525200413.GA29664@izvekov.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matheus Izvekov wrote:
> Got this BUG_ON twice in a row, just found it by scrolling thru my
> dmesg.
> 
> BUG: at fs/inotify.c:172 set_dentry_child_flags()

http://bugzilla.kernel.org/show_bug.cgi?id=7785

If you can reproduce it, looks like some help diagnosing it would be useful.

Daniel

