Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbYJXQ0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbYJXQ0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 12:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYJXQ0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 12:26:07 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:36796 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750747AbYJXQ0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 12:26:06 -0400
Message-ID: <4901F715.8060409@lwfinger.net>
Date: Fri, 24 Oct 2008 09:25:57 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usbcore: Limit number of 'unable to enumerate USB	device'
 messages
References: <49010A25.6020702@lwfinger.net> <20081023233619.GA21531@suse.de>
In-Reply-To: <20081023233619.GA21531@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

> What kernel version are you having these problems with?

This problem started sometime in the 2.6.26-git sequence, and persists to the
latest from the linux-2.6 git tree.

Larry
