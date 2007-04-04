Return-Path: <linux-kernel-owner+w=401wt.eu-S1753871AbXDDO1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbXDDO1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 10:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbXDDO1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 10:27:47 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:16986 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753871AbXDDO1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 10:27:47 -0400
Message-ID: <4613B5EF.90805@cfl.rr.com>
Date: Wed, 04 Apr 2007 10:27:59 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: pktsetup and dvd movie
References: <46129997.3050209@m3y3r.de>
In-Reply-To: <46129997.3050209@m3y3r.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Apr 2007 14:27:55.0209 (UTC) FILETIME=[6F590B90:01C776C5]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15096.000
X-TM-AS-Result: No--7.312700-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer wrote:
> On my pc i encounter a strange error:
> the pktsetup is started during system start and set my dvd driver to
> packet writing mode. then i insert a dvd movie and start xine. and
> sometimes xine says that it can't play the dvd. BUT after
> stoping/removing the pktsetup from the dvd drive again, xine plays the
> dvd movie without problems.
> 
> I have no idea were to start! Does anybody encounter a similar error?
> Any ideas?

I am confused.... did you burn this dvd with pktcdvd, or is this a 
factory pressed dvd that you are unable to play via /dev/pktcdvd but can 
with /dev/dvd?

