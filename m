Return-Path: <linux-kernel-owner+w=401wt.eu-S933325AbXEEUQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325AbXEEUQf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 16:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933320AbXEEUQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 16:16:35 -0400
Received: from h155.mvista.com ([63.81.120.155]:21052 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933307AbXEEUQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 16:16:34 -0400
Message-ID: <463CE681.9050000@ru.mvista.com>
Date: Sun, 06 May 2007 00:18:09 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: michal.kepien@poczta.onet.pl, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH pata-2.6 fix queue] hpt366: don't check enablebits for
 HPT36x
References: <200705042318.37367.sshtylyov@ru.mvista.com> <200705052130.53793.bzolnier@gmail.com>
In-Reply-To: <200705052130.53793.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

>>HPT36x chip don't seem to have the channel enable bits, so prevent the IDE core
>>from checking them...

>>Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> applied

    I'm getting "403 Forbidden" trying to browse this patch (and 
ide-cs-recognize-2gb-compactflash-from-transcend.patch as well).

MBR, Sergei
