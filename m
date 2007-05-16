Return-Path: <linux-kernel-owner+w=401wt.eu-S1760805AbXEPH6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760805AbXEPH6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 03:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759533AbXEPH5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 03:57:50 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54494 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758379AbXEPH5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 03:57:50 -0400
Message-ID: <464AB979.2020107@garzik.org>
Date: Wed, 16 May 2007 03:57:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Henry Su <henry.su@amd.com>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, gmail_ati <henry.su.ati@gmail.com>
Subject: Re: [PATCH 4/4] Add the combined mode for ATI SB700
References: <FFECF24D2A7F6D418B9511AF6F35860201A4D662@shacnexch2.atitech.com>
In-Reply-To: <FFECF24D2A7F6D418B9511AF6F35860201A4D662@shacnexch2.atitech.com>
Content-Type: text/plain; charset=UTF-7
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Henry Su wrote:
> From: henry.su@amd.com
> Besides those modes in ATI SB600 SATA controller, ATI SB700 supports one more mode:the combined mode.
> 
> The combined mode is a Legacy IDE mode used for compatibility with some old OS without AHCI driver, 
> but now it is not necessary for Linux since the kernel has supported AHCI.

hmmmm.  The patch looks OK, but your description seems to indicate that
the patch is not needed?

	Jeff



