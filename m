Return-Path: <linux-kernel-owner+w=401wt.eu-S2992627AbXCWXI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992627AbXCWXI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 19:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992617AbXCWXI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 19:08:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992627AbXCWXI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 19:08:58 -0400
Message-ID: <46045D8B.8020201@redhat.com>
Date: Fri, 23 Mar 2007 19:06:51 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.21-rc regression in mptbase
References: <Pine.LNX.4.61.0703232322030.10028@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0703232322030.10028@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Hello world,
> 
> 
> in at least 2.6.21-rc4, one or more of the mptscsi scsi modules is 
> broken with respect to not detecting any harddisk (VMware provides that 
> virtual LSI MPT controller), which means no working system.
> No problems in 2.6.20.2.
> 
> I will be trying 2.6.21-rc1 shortly.
> 

Also try 2.6.20.4. There are reports of this problem there as well.


