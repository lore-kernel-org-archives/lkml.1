Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbZHKQFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbZHKQFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbZHKQFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:05:16 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:43381 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbZHKQFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:05:15 -0400
Message-ID: <4A81969B.4000601@nortel.com>
Date: Tue, 11 Aug 2009 10:04:43 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Al Boldi <a1426z@gawab.com>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       gregkh@suse.de, Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
References: <20090805171513.GA10443@kroah.com> <200908110648.26191.a1426z@gawab.com> <20090811040431.GA1178@kroah.com> <200908111818.16399.a1426z@gawab.com> <20090811154931.GA25079@kroah.com>
In-Reply-To: <20090811154931.GA25079@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Aug 2009 16:04:44.0722 (UTC) FILETIME=[71576120:01CA1A9D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

> Again, I don't really believe that you use a CONFIG_HOTPLUG=n system in
> the real world, so barring a patch from you or anyone else, I'll leave
> it as-is.

That seems a bit harsh.  There are lots of embedded devices that don't
need hotplug.

Chris
