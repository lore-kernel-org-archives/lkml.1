Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbYBQHiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbYBQHiQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 02:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbYBQHhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 02:37:41 -0500
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:20652 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755186AbYBQHhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 02:37:23 -0500
To: Daniel Barkalow <barkalow@iabervon.org>
Subject: Re: [REGRESSION 2.6.23] no vga console and no messages
Cc: linux-kernel@vger.kernel.org
In-reply-To: <alpine.LNX.1.00.0802162042130.6093@iabervon.org>
References: <alpine.LNX.1.00.0802162042130.6093@iabervon.org>
Message-Id: <E1JQe5R-0001cW-1a@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Sun, 17 Feb 2008 08:37:21 +0100
X-OriginalArrivalTime: 17 Feb 2008 07:37:21.0407 (UTC) FILETIME=[EE3B68F0:01C87137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Barkalow wrote:
> For some reason I can't see and don't know how to debug, in 2.6.23 on my
> server I don't get the vga console, but only get the dummy console.

Please check if this bug report matches the issue you are seeing:
http://bugzilla.kernel.org/show_bug.cgi?id=9310

Cheers,
FJP
