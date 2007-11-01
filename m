Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbXKAUbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbXKAUbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 16:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbXKAUbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 16:31:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48321 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752636AbXKAUbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 16:31:06 -0400
Date: Thu, 1 Nov 2007 13:31:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Amit Shah" <shahamit@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: sata_nv: ata2 errors
Message-Id: <20071101133102.1121bc28.akpm@linux-foundation.org>
In-Reply-To: <877aabc40710250048m41675163x81671097f44bba7f@mail.gmail.com>
References: <877aabc40710250048m41675163x81671097f44bba7f@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 13:18:50 +0530
"Amit Shah" <shahamit@gmail.com> wrote:

> On 2.6.24-rc1 (AMD Opteron 1216), my sata_nv driver produces this
> output on bootup:
> 
> ata2: EH in SWNCQ mode,QC:qc_active 0x1 sactive 0x1
> ata2: SWNCQ:qc_active 0x1 defer_bits 0x0 last_issue_tag 0x0
> ata2: ATA_REG 0x40 ERR_REG 0x0
> ata2: tag : dhfis dmafis sdbfis sacitve
> ata2: tag 0x0: 0 1 0 0
> ata2.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
> ...
> ata2.00: status: { DRDY }
> 

Are any other problems observeable?

Did 2.6.23 do this?
