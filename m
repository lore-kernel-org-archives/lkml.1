Return-Path: <linux-kernel-owner+w=401wt.eu-S933645AbXGWAeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933645AbXGWAeQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 20:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764545AbXGWAd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 20:33:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:37698 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763926AbXGWAdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 20:33:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=WKJFcqFafopK1VwlYsHgf3NRWvf5XNKcTXn5L/vmgIz9O/qKLJk84nkgc6eizH92a+Q9deGZ4em6qKIecKD3nR/XD4rKENYw+6bFbcBHpqbeormxDY29yYNDWlC12v9pmWvxhxJJH+j5i7hQNjw7PLmk53xWauubdbkDYTYRm7E=
Message-ID: <46A3F6E2.1040606@googlemail.com>
Date: Mon, 23 Jul 2007 02:31:30 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-git17 boot failure
References: <46A3EC92.3050504@imap.cc>
In-Reply-To: <46A3EC92.3050504@imap.cc>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> On my test machine with a Pentium D 940 processor, Intel DQ965GF
> mainboard and SATA disks, kernel 2.6.22-git17 (32 bit build) fails
> to come up because it cannot find the disk drives. Same issue
> with a clone of the 'linus' git tree. Anything known?
> 

Could you post the config ?


Regards,

Gabriel C
