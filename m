Return-Path: <linux-kernel-owner+w=401wt.eu-S1030860AbXDMWX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030860AbXDMWX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 18:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030853AbXDMWX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 18:23:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030860AbXDMWX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 18:23:58 -0400
Message-ID: <462002A9.9060008@redhat.com>
Date: Fri, 13 Apr 2007 18:22:33 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.20.7
References: <20070413205659.GA5935@kroah.com> <461FFC19.1020208@redhat.com> <20070413220302.GB7366@suse.de>
In-Reply-To: <20070413220302.GB7366@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>>>
>>> The updated 2.6.20.y git tree can be found at:
>>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git
>>> and can be browsed at the normal kernel.org git web browser:
>>>         www.kernel.org/git/
>> How long should that take to show up on kernel.org?
> 
> I see it there already, must be a slow mirror...

$ wget http://www1.kernel.org/pub/linux/kernel/v2.6/patch-2.6.20.7.bz2
--18:21:45--  http://www1.kernel.org/pub/linux/kernel/v2.6/patch-2.6.20.7.bz2
Resolving www1.kernel.org... 204.152.191.5
Connecting to www1.kernel.org|204.152.191.5|:80... connected.
HTTP request sent, awaiting response... 404 Not Found
18:21:46 ERROR 404: Not Found.

$ wget http://www2.kernel.org/pub/linux/kernel/v2.6/patch-2.6.20.7.bz2
--18:21:51--  http://www2.kernel.org/pub/linux/kernel/v2.6/patch-2.6.20.7.bz2
Resolving www2.kernel.org... 204.152.191.37
Connecting to www2.kernel.org|204.152.191.37|:80... connected.
HTTP request sent, awaiting response... 404 Not Found
18:21:52 ERROR 404: Not Found.
