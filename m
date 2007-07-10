Return-Path: <linux-kernel-owner+w=401wt.eu-S1763575AbXGJU3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763575AbXGJU3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760565AbXGJU3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:29:23 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:16512 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760425AbXGJU3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:29:22 -0400
Message-ID: <4693EC9B.6020305@ru.mvista.com>
Date: Wed, 11 Jul 2007 00:31:23 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: ata and netdev (was Re: -mm merge plans for 2.6.23)
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>	<4693C4F8.40903@garzik.org> <20070710112458.e9dbb55e.akpm@linux-foundation.org>
In-Reply-To: <20070710112458.e9dbb55e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Andrew Morton wrote:

> 3x59x-fix-pci-resource-management.patch: you wrote it ;) I have a comment

    No, I did, almost a year ago already. :-)

> here:

> - I don't remember the story with cardbus either.  Presumably once upon a
>   time the cardbus layer was claiming IO regions on behalf of cardbus
>   devices (?)

    IIRC, that's your own comment.

> Need to think about that.

WBR, Sergei
