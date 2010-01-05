Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660Ab0AEKW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab0AEKW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 05:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741Ab0AEKW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 05:22:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab0AEKW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 05:22:57 -0500
Date: Tue, 5 Jan 2010 11:22:56 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: kernel-janitors@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>,
       =?ISO-8859-15?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] isdn/hardware: add __init/__exit macros to
 isdn/hardware/mISDN/mISDNisar.c
In-Reply-To: <1261470431-23642-2-git-send-email-peterhuewe@gmx.de>
Message-ID: <alpine.LNX.2.00.1001051122250.2277@pobox.suse.cz>
References: <1261470431-23642-1-git-send-email-peterhuewe@gmx.de> <1261470431-23642-2-git-send-email-peterhuewe@gmx.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009, peterhuewe@gmx.de wrote:

> From: Peter Huewe <peterhuewe@gmx.de>
> 
> Trivial patch which adds the __init/__exit macros to the module_init/
> module_exit functions of
> 
> drivers/isdn/hardware/mISDN/mISDNisar.c

The patch doesn't seem to be present in linux-next as of today. I have 
applied it to my queue.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
