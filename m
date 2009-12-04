Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbZLDPR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbZLDPR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 10:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbZLDPRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 10:17:25 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:21991 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbZLDPRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 10:17:24 -0500
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4B192803.1080008@tremplin-utc.net>
Date: Fri, 04 Dec 2009 16:17:23 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091009 Mandriva/2.0.0.23-3mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.32: scsi_wait_scan bug
References: <alpine.DEB.2.00.0912040943420.3540@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.0912040943420.3540@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 04-12-09 15:44, Justin Piszcz schreef:
> Hello,
> 
> Checking the /lib/modules directory for 2.6.32, I noticed this bug still
> persists:
> https://lists.linux-foundation.org/pipermail/bugme-new/2007-August/016634.html
> 
> 
> Was wondering if it should be able to be enabled or disabled in the
> menuconfig (as you cannot currently see that option)?
Hi,

Your link eventually leads to this patch:
http://lkml.indiana.edu/hypermail/linux/kernel/0906.2/00861.html

Isn't this answering your question?

Eric
