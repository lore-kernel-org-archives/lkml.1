Return-Path: <linux-kernel-owner+w=401wt.eu-S1757844AbZHGMsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844AbZHGMsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 08:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757820AbZHGMsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 08:48:50 -0400
Received: from mailhost3.gawab.com ([66.220.20.3]:58087 "HELO info8.gawab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757809AbZHGMsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 08:48:50 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based /dev
Date: Fri, 7 Aug 2009 15:49:21 +0300
User-Agent: KMail/1.5
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
References: <20090805171513.GA10443@kroah.com> <200908070804.08156.a1426z@gawab.com> <20090807052015.GA24615@kroah.com>
In-Reply-To: <20090807052015.GA24615@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908071549.21416.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> It's much faster than udev, and is equivalent to a static /dev with the
> exception that the group and permission settings that you are used to.
> udev then needs to come along and make those settings, but that's so
> frickin fast it's amazing.

Sounds great!

> So, test it out and see if you want to verify this.

Ok, can you post a patch against .30?


Thanks!

--
Al

