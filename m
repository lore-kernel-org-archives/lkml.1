Return-Path: <linux-kernel-owner+w=401wt.eu-S1758288AbZDXVV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbZDXVV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 17:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbZDXVVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 17:21:20 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57725 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbZDXVVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 17:21:20 -0400
Message-ID: <49F22D49.6000806@garzik.org>
Date: Fri, 24 Apr 2009 17:21:13 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: LCID Fire <lcid-fire@gmx.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Link to sata drives fail randomly
References: <49F210C2.8050703@gmx.net>
In-Reply-To: <49F210C2.8050703@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LCID Fire wrote:
> First of - I have a Asus P5K WS where I'm running (or actually trying) a 
> raid10 based on 4 sata drives. All drives are connected to esata slot 
> panels which connect to the mainboard ports.
> The problem I'm encountering is the links to random drives fail every 
> week or so.
> The strange thing is - the link is often failing for 2 drives at a time 
> - which is the best when running a raid10 *sarcasm*
> The drives are WD, Samsung and Hitachi - so I think some specific driver 
> failure can be ruled out.
> I attached the dmesg - perhaps someone could tell me which component is 
> responsible for my drives losing their link.

Looks like a flaky cable, or bad connector.

	Jeff



