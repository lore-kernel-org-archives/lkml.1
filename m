Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbYGPGhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbYGPGhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 02:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbYGPGhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 02:37:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58522 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbYGPGhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 02:37:42 -0400
Message-ID: <487D96A2.10904@jp.fujitsu.com>
Date: Wed, 16 Jul 2008 15:35:14 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Max Krasnyansky <maxk@qualcomm.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       virtualization@lists.linux-foundation.org,
       Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] stopmachine: add stopmachine_timeout v2
References: <487B05CE.1050508@jp.fujitsu.com> <487D78A3.6050105@jp.fujitsu.com> <487D93CD.1000007@qualcomm.com>
In-Reply-To: <487D93CD.1000007@qualcomm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Krasnyansky wrote:
> I'd set the default to zero. I beleive that's what Heiko suggested too.

Oh, yes, you are right.  I missed to catch the suggestion.
I'll post fixed version soon.  Wait a minutes...

Thanks,
H.Seto
