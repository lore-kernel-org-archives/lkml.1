Return-Path: <linux-kernel-owner+w=401wt.eu-S1760088AbYBRMg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760088AbYBRMg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758562AbYBRMgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:36:49 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51163 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbYBRMgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:36:48 -0500
Message-ID: <47B97BD5.5070209@garzik.org>
Date: Mon, 18 Feb 2008 07:36:37 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Greg KH <greg@kroah.com>, Sam Ravnborg <sam@ravnborg.org>, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
References: <098123kjff90231nv098233rnvd908u234@garzik.org>	<20080217195235.GN14588@uranus.ravnborg.org>	<20080218045209.GA15141@kroah.com> <p73zltyxy9q.fsf@bingen.suse.de>
In-Reply-To: <p73zltyxy9q.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Merging essentially untested patches does not seem like a good strategy.

Agreed.  I don't want my stuff going in without knowing it works.


> And there is definitely still a large ISDN user base too.

This is what I'm curious about.  My personal guess is that there is a 
lot of ISDN hardware available, but not necessarily the telco ISDN 
availability.  But I have no way to gauge the Linux ISDN userbase size 
(beyond responses from isdn maintainers and list users), so I'm a poor 
judge.

	Jeff



