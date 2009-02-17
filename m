Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbZBQCoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbZBQCoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 21:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZBQCnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 21:43:51 -0500
Received: from rtr.ca ([76.10.145.34]:36535 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbZBQCnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 21:43:50 -0500
Message-ID: <499A2464.2080602@rtr.ca>
Date: Mon, 16 Feb 2009 21:43:48 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       =?UTF-8?B?SGFubm8gQsO2Y2s=?= <hanno@hboeck.de>
Subject: Re: [PATCH] libata: Don't trust current capacity values in identify
 words 57-58
References: <4999CA54.1060306@gmail.com> <4999F032.6060107@rtr.ca> <4999FAF2.1000800@gmail.com>
In-Reply-To: <4999FAF2.1000800@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
..
> This is the !ata_id_has_lba code path. If the drive supports LBA then 
> the LBA capacity will always be used, that hasn't changed.
..

Oh, good.  No problems then!

Cheers
