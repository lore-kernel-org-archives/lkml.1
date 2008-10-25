Return-Path: <linux-kernel-owner+w=401wt.eu-S1752582AbYJYDRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbYJYDRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 23:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbYJYDQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 23:16:50 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:54460 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751256AbYJYDQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 23:16:50 -0400
Message-ID: <49028F9D.3020208@lwfinger.net>
Date: Fri, 24 Oct 2008 20:16:45 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Greg KH <gregkh@suse.de>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usbcore: Limit number of 'unable to enumerate USB	device'
 messages
References: <49010A25.6020702@lwfinger.net> <20081023233619.GA21531@suse.de> <4901F715.8060409@lwfinger.net> <20081024170024.GA14189@kroah.com>
In-Reply-To: <20081024170024.GA14189@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> 
> The latest tree should warn you if you load the host controller drivers
> in the wrong order, so this shouldn't really be an issue anymore, right?

I have not seen such warhings, thus I expect loading is in the proper order.
> 
> Like Alan said, proper log messages would be helpful here.

Agreed, but I have no idea what I should be looking for. For the moment, I have
lots of test prints looking for the sequence of events that lead to this
spamming of the logs.

Larry
