Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbXITOTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbXITOTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 10:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbXITOTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 10:19:13 -0400
Received: from twin.jikos.cz ([213.151.79.26]:59589 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755773AbXITOTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 10:19:12 -0400
Date: Thu, 20 Sep 2007 16:19:07 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Pavel Machek <pavel@ucw.cz>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ACPI video mode patch review
In-Reply-To: <46E9AD88.7070400@zytor.com>
Message-ID: <Pine.LNX.4.64.0709201617440.24429@twin.jikos.cz>
References: <46E9AD88.7070400@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007, H. Peter Anvin wrote:

> Pavel, want to look at the patch before sending it to Linus?

Hi,

sorry for this taking too long, I was physically located away from the 
hardware. 

Without your patch, after resume I got corrupted image (looked like 
remains of BIOS POST graphics, in bad resolution, or something like that).

With your patch applied, I get no video at all after resume (I tried all 
three possible combinations of acpi_sleep parameter).

-- 
Jiri Kosina
