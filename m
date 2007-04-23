Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbXDWXa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbXDWXa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 19:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbXDWXa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 19:30:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbXDWXaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 19:30:24 -0400
Message-ID: <462D40F5.5050704@redhat.com>
Date: Mon, 23 Apr 2007 19:27:49 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <liml@rtr.ca>,
       Stephen.Clark@seclark.us, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, 7eggert@gmx.de,
       emisca <emisca.ml@gmail.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
Subject: Re: Loud "pop" coming from hard drive on reboot
References: <88SeR-5Sf-15@gated-at.bofh.it> <46265307.7060405@rtr.ca>	 <46265966.1040102@redhat.com> <200704182322.20514.bzolnier@gmail.com>	 <46268D27.9070809@redhat.com> <1177197606.7316.44.camel@twins>
In-Reply-To: <1177197606.7316.44.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> 
> but I have an increasing seek error rate as well. I got the ST disk
> because thinkwiki suggested it.
> 

Apparently Seagate has their own definition of seek error rate.
Large numbers are normal, or at least very common.

Now I wonder if they have their own way of doing retract count...
