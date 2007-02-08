Return-Path: <linux-kernel-owner+w=401wt.eu-S1423007AbXBHOaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423007AbXBHOaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 09:30:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423042AbXBHOaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 09:30:12 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:45579 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423007AbXBHOaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 09:30:11 -0500
Message-ID: <45CB33F1.2060802@garzik.org>
Date: Thu, 08 Feb 2007 09:30:09 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Junio C Hamano <junkio@cox.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver updates
References: <20070208002959.GA29961@havoc.gtf.org> <7vired2mb9.fsf@assigned-by-dhcp.cox.net>
In-Reply-To: <7vired2mb9.fsf@assigned-by-dhcp.cox.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano wrote:
> Jeff Garzik <jeff@garzik.org> writes:
> 
>>  mode change 100644 => 100755 drivers/net/qla3xxx.c
>>  mode change 100644 => 100755 drivers/net/qla3xxx.h
> 
> Did you mean to have these?  Commit bd36b0ac appears to have
> brought the mode bits change in.
> 
> Not trying to nitpick --- I am trying to find out if this was
> caused by a git bug.

No idea, presumably not.

FWIW I never chmod anything source in the kernel tree, so I'm guessing 
that maybe the patch associated with the commit contained mode bits?

	Jeff



