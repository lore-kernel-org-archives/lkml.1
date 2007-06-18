Return-Path: <linux-kernel-owner+w=401wt.eu-S1764333AbXFRQA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764333AbXFRQA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 12:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757472AbXFRQAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 12:00:50 -0400
Received: from terminus.zytor.com ([192.83.249.54]:47551 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762504AbXFRQAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 12:00:49 -0400
Message-ID: <4676AC2D.1050107@zytor.com>
Date: Mon, 18 Jun 2007 09:00:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: implementation of boot-time kernel parameters
References: <Pine.LNX.4.64.0706180709390.14098@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0706180709390.14098@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> 
>   i'm also aware of an older and (apparently) LILO-specific way to do
> it -- using something like "pas16=" where the appropriate driver code
> has to parse the value string (eg., in drivers/scsi/pas16.c):
> 

Utter nonsense.  The only reason these older drivers mention "LILO" is
because some of these driver authors thought LILO was the only native
Linux bootloader.

	-hpa
