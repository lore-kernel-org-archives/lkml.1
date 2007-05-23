Return-Path: <linux-kernel-owner+w=401wt.eu-S1765299AbXEWN1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765299AbXEWN1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 09:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbXEWN1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 09:27:15 -0400
Received: from rtr.ca ([64.26.128.89]:4425 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516AbXEWN1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 09:27:14 -0400
Message-ID: <46544130.1010901@rtr.ca>
Date: Wed, 23 May 2007 09:27:12 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: Dmitry Torokhov <dtor@insightbb.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Race free attributes in sysfs
References: <46502A8B.70803@drzeus.cx> <200705202312.19191.dtor@insightbb.com> <46535F7F.1040504@rtr.ca> <200705222243.56007.dtor@insightbb.com> <20070523042145.GA27329@kroah.com>
In-Reply-To: <20070523042145.GA27329@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> 
> And yes, it only starts to look for things when it recieves an event, it
> does not "scan" sysfs at all.

Does it "look for" only that one event, or does it "scan" at that point?
