Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbYJVLtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbYJVLtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 07:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYJVLtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 07:49:43 -0400
Received: from h155.mvista.com ([63.81.120.155]:33336 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752165AbYJVLtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 07:49:42 -0400
Message-ID: <48FF134F.2070509@ru.mvista.com>
Date: Wed, 22 Oct 2008 15:49:35 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] IDE updates #4
References: <200810212100.52985.bzolnier@gmail.com>
In-Reply-To: <200810212100.52985.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> Remove needless/confusing subdirs from drivers/ide/.
>   

   I think that with 2 new drivers being submitted/reworked based on 
feedback and several patches submitted and pending submission to the 
pata-2.6 series this really could have waited till 2.6.29...

MBR, Sergei


