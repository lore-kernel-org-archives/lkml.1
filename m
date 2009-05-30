Return-Path: <linux-kernel-owner+w=401wt.eu-S1759521AbZE3Lgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbZE3Lgc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 07:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757581AbZE3LgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 07:36:23 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:42210 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756594AbZE3LgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 07:36:23 -0400
Message-ID: <4A211A2E.7090301@f2s.com>
Date: Sat, 30 May 2009 12:36:14 +0100
From: Ian molton <spyro@f2s.com>
Reply-To: ian@mnementh.co.uk
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Philipp Zabel <philipp.zabel@gmail.com>
CC: linux-kernel@vger.kernel.org, Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH 5/5] mmc: tmio_mmc: move probe function into __init section
References: <1243279681-4233-1-git-send-email-philipp.zabel@gmail.com> <1243279681-4233-6-git-send-email-philipp.zabel@gmail.com>
In-Reply-To: <1243279681-4233-6-git-send-email-philipp.zabel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philipp Zabel wrote:
> As MFD cells are not hotpluggable, this should be safe to do.

NAK, as per others comments.
