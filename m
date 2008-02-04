Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbYBDI3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbYBDI3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 03:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbYBDI3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 03:29:25 -0500
Received: from mx38.mail.ru ([194.67.23.16]:51275 "EHLO mx38.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbYBDI3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 03:29:24 -0500
Message-ID: <47A6CCD0.7050107@mail.ru>
Date: Mon, 04 Feb 2008 10:29:04 +0200
From: Alexander <aledin@mail.ru>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>
Subject: Re: PROBLEM REMAINS: [sata_nv ADMA breaks ATAPI] Crash on accessing
 DVD-RAM
References: <fa.krOVfyFmB2aqGjJIoHCLmQxecWc@ifi.uio.no> <47A2633B.8080807@shaw.ca>
In-Reply-To: <47A2633B.8080807@shaw.ca>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Can you (or others experiencing this problem) test the latest patch 
> attached to the RH Bugzilla entry here:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=351451
> 
> and see if it resolves the problem? I have one report of success so far.

I've tested this patch and it seems to work OK with my hardware. Thank you!

