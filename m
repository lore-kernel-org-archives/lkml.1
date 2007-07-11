Return-Path: <linux-kernel-owner+w=401wt.eu-S934046AbXGKTeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934046AbXGKTeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763366AbXGKTV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:21:29 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4839 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452AbXGKTV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:21:28 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 11 Jul 2007 12:21:21 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Adrian Bunk <bunk@stusta.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [2.6 patch] ANON_INODES shouldn't be user visible
In-Reply-To: <20070711182607.GM3492@stusta.de>
Message-ID: <Pine.LNX.4.64.0707111220310.12308@alien.or.mcafeemobile.com>
References: <20070711182607.GM3492@stusta.de>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, Adrian Bunk wrote:

> There doesn't seem to be a good reason for ANON_INODES being
> an user visible option.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Sure, makes sense.

Acked-by: Davide Libenzi <davidel@xmailserver.org>



- Davide


