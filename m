Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbYKDStW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbYKDStW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 13:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbYKDStO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 13:49:14 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:33110 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751520AbYKDStN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 13:49:13 -0500
Message-ID: <4910991B.5010903@euromail.se>
Date: Tue, 04 Nov 2008 19:48:59 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: Add support for the new unibody macbooks
References: <49103CFA.1010707@euromail.se> <49106747.8060709@gmail.com>
In-Reply-To: <49106747.8060709@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1KxQxi-0001BB-6X.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KxQxi-0001BB-6X 4c27ebc404dc3fcb57e7b2b699f8e42a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Henrik Rydberg napsal(a):
>> The unibody MacBook 5 and MacBook Pro 5 come with a new version of
>> the bcm5974 trackpad. This patch adds the USB device ids and the
>> appropriate quirks.
> 
> Hi, thanks for the patch, but you omitted hid_blacklist addition.
> 
> Jiri K. (HID maintainer) is out for a while, expect longer rtt ;).

Yes, I sent it separately, sorry about the confusion. I will resend
the whole patch shortly, with the blacklist included. Thanks!

