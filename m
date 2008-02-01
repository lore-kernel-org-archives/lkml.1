Return-Path: <linux-kernel-owner+w=401wt.eu-S1760003AbYBAKH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003AbYBAKH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 05:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755047AbYBAKHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 05:07:16 -0500
Received: from styx.suse.cz ([82.119.242.94]:51207 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754870AbYBAKHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 05:07:14 -0500
Date: Fri, 1 Feb 2008 11:07:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: how to tell i386 from x86-64 kernel
In-Reply-To: <47A2A54B.90703@zytor.com>
Message-ID: <Pine.LNX.4.64.0802011105430.22844@jikos.suse.cz>
References: <20080201004212.GA2818@elf.ucw.cz> <47A2A54B.90703@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008, H. Peter Anvin wrote:

> > Quiz: on a booted system, how do you tell 32bit from 64bit kernel?
> uname -m

I think that the real point here is that there is no general way how to 
determine whether the kernel is 32bit or 64bit from full dmesg output, 
which could sometimes make debugging user-reported bugs a little bit 
harder.

-- 
Jiri Kosina
SUSE Labs
