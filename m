Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbYESAdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbYESAdo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 20:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYESAdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 20:33:37 -0400
Received: from mail.plusnet.pl ([212.2.119.243]:65455 "EHLO mail.plusnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470AbYESAdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 20:33:36 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Message-id: <4830CAF8.405@plusnet.pl>
Date: Mon, 19 May 2008 02:34:00 +0200
From: Stawi <stawi@plusnet.pl>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
To: linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>
Subject: Re: Linux 2.6.24 kernel BUG at fs/buffer.c:450
References: <4823830E.4090301@plusnet.pl>
 <20080514160517.GA22140@atrey.karlin.mff.cuni.cz>
In-reply-to: <20080514160517.GA22140@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This was not a bug. I figured out that it was caused by bad memory. 
Memtest86 *did not* reported any errors, so, as to me, is useless.
My PC goes crazy as I said, and other one PC (with WinXP) went crazy as 
well.

 If some one wants, i can send ~5 more crash reports, almost every is 
diffrent ;)

Kind regards,
Stawi
