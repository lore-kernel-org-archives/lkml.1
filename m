Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbXGVVn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbXGVVn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 17:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbXGVVnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 17:43:50 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:46985 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754007AbXGVVnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 17:43:49 -0400
Date: Sun, 22 Jul 2007 23:47:10 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, cornelia.huck@de.ibm.com
Subject: Re: [bug] pcwd_init_module(): WARNING: at lib/kref.c:33 kref_get()
Message-ID: <20070722214710.GA31322@infomag.infomag.iguana.be>
References: <20070722124224.GA20382@elte.hu> <a781481a0707220753q2754f3cfy47941405f92c833d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0707220753q2754f3cfy47941405f92c833d@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

> On 7/22/07, Ingo Molnar <mingo@elte.hu> wrote:
> >
> >enabling CONFIG_PCWATCHDOG=y crashes bzImage bootup, see below. Tested
> >on latest -git.

I'll have a look at it when I'm back home and I can test it (within a week).

Greetings,
Wim.
