Return-Path: <linux-kernel-owner+w=401wt.eu-S1757828AbXKARSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828AbXKARSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbXKARRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:17:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbXKARRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:17:52 -0400
Message-ID: <472A0A36.1050403@redhat.com>
Date: Thu, 01 Nov 2007 13:17:42 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Romano Giannetti <romanol@upcomillas.es>
CC: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Subject: Re: 2.6.34-rc1 eat my photo SD card :-(
References: <1193918202.8439.7.camel@rukbat>
In-Reply-To: <1193918202.8439.7.camel@rukbat>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2007 07:56 AM, Romano Giannetti wrote:
> Hi,
> 
> 	I have a very possible regression to signal. This morning 2.6.24-rc1
> eat and destroyed my SD card. I have a toshiba laptop with a card slot
> and I have used it with 2.6.23-rcX and 2.6.23 without problems so far.
> This morning I put the card in, nothing happened, removed it. When I put
> it in again the filesystem in it was completely scr***ed up. 
> 

I always flip the write-protect switch when I use mine with a computer,
and only let the camera write to the card.
