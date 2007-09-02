Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbXIBSrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbXIBSrD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 14:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbXIBSqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 14:46:55 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59950 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbXIBSqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 14:46:55 -0400
Message-ID: <46DB051D.3010008@garzik.org>
Date: Sun, 02 Sep 2007 14:46:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "Jonathan A. George" <jageorge@austin.rr.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: "GPL weasels and the atheros stink"
References: <46DAF70E.9060800@austin.rr.com>
In-Reply-To: <46DAF70E.9060800@austin.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan A. George wrote:
> Question #1: Is it _ethical_ (legality aside) to take someone else's 
> actively maintained work (for example an OpenBSD driver) and make 
> changes which can not be shared/used by the original developer/maintainer?

This happens all the time.  It's called a fork.

Forks happen for good reasons, bad reasons, dumb reasons, and smart reasons.

Sometimes the useful changes can be shared back, and that's a good thing 
[for that situation].

Sometimes changes cannnot be shared back, and that's also a good thing 
[for that situation].


> Question #2: Is it _technically beneficial_ to branch an OSS work (for 
> example an OpenBSD driver) in such a way as to diminish the ability to 
> share contributions between projects?

Can only be answered on a case-by-case basis.

The reality OF THE CODE is such that *BSD and Linux share good SOLUTIONS 
quite often.  That's a benefit of open source.  And that's a good thing.

	Jeff


