Return-Path: <linux-kernel-owner+w=401wt.eu-S1030572AbXDQVvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030572AbXDQVvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 17:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965084AbXDQVvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 17:51:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965030AbXDQVvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 17:51:14 -0400
Message-ID: <462540CD.9080406@redhat.com>
Date: Tue, 17 Apr 2007 17:49:01 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: emisca <emisca.ml@gmail.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
Subject: Re: Loud "pop" coming from hard drive on reboot
References: <461D4E2C.6000704@redhat.com>	 <Pine.LNX.4.61.0704112315480.20436@yvahk01.tjqt.qr>	 <461D54AF.3060706@redhat.com> <414cba4e0704150907r215bf196n637070dd40bccc3b@mail.gmail.com> <46253F14.4020304@rtr.ca>
In-Reply-To: <46253F14.4020304@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> 
> I'll patch it locally on my own machines, but what about the tens
> of thousands of other Seagate notebook drive owners out there?
> 

This is a problem with Seagate specifically, spinning back up
on receipt of some command after spindown?

