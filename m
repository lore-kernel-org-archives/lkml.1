Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbYJ3XTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbYJ3XTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 19:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbYJ3XTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 19:19:18 -0400
Received: from styx.suse.cz ([82.119.242.94]:49651 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754734AbYJ3XTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 19:19:16 -0400
Date: Fri, 31 Oct 2008 00:19:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: hid: struct device - replace bus_id with dev_name(),
 dev_set_name()
In-Reply-To: <ac3eb2510810301616n271102fcred30bc1eef6a8dba@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0810310018210.31273@jikos.suse.cz>
References: <1225385705.21973.20.camel@nga.site> <490A0A35.9060606@gmail.com>  <1225395316.21973.47.camel@nga.site>  <alpine.LNX.1.10.0810310009110.31273@jikos.suse.cz> <ac3eb2510810301616n271102fcred30bc1eef6a8dba@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008, Kay Sievers wrote:

> >> Subject: hid: struct device - replace bus_id with dev_name(), dev_set_name()
> > thanks for this cleanup. What is the timeframe the bus_id will be removed
> > from struct device?
> Hmm, not sure. We will put the remaining pieces into Greg's tree, wait
> for -next to carry most of it, and convert the rest. Maybe we can do
> it for the next kernel, but we might get sidetracked again, and it
> might take longer.

OK, thanks. I just wanted to know how much hurry do you expect from 
subsystem maintainers with this change.

I have queued it for 2.6.29 now in my tree, thanks.

-- 
Jiri Kosina
SUSE Labs
