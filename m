Return-Path: <linux-kernel-owner+w=401wt.eu-S1758980AbXJRU6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980AbXJRU6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 16:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755099AbXJRU55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 16:57:57 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60782 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698AbXJRU55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 16:57:57 -0400
Message-ID: <4717C8CD.9010300@garzik.org>
Date: Thu, 18 Oct 2007 16:57:49 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@qumranet.com>, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: latest checkpatch
References: <20071015182118.GA4459@shadowen.org> <200710161759.l9GHxnkK012590@agora.fsl.cs.sunysb.edu> <20071017163916.GO21136@shadowen.org> <20071018111352.GA17039@elte.hu> <20071018192521.GC21136@shadowen.org> <20071018193929.GA22031@elte.hu> <4717BBD0.7070504@qumranet.com> <20071018205147.GA1382@elte.hu>
In-Reply-To: <20071018205147.GA1382@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> there's "checkpatch --file" for complete files, so it can see the full 
> context if the user passes it in.

This is new, I guess?

[jgarzik@pretzel linux-2.6]$  scripts/checkpatch.pl --file 
drivers/ata/libata-eh.c
Unknown option: file

Such an option would be quite useful, but does not appear in upstream.

Also, upstream lacks support for "-h" and "--help" so you get to guess 
at the options.

	Jeff


