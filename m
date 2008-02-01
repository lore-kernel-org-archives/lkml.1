Return-Path: <linux-kernel-owner+w=401wt.eu-S1758811AbYBAQzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811AbYBAQzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 11:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbYBAQzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 11:55:47 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:60641 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212AbYBAQzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 11:55:46 -0500
Message-ID: <47A34F0E.104@garzik.org>
Date: Fri, 01 Feb 2008 11:55:42 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] ata_piix.c: make piix_merge_scr() static
References: <20080128221019.GN8767@does.not.exist>
In-Reply-To: <20080128221019.GN8767@does.not.exist>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> piix_merge_scr() can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

applied


