Return-Path: <linux-kernel-owner+w=401wt.eu-S1754289AbYGQFhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbYGQFhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 01:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbYGQFh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 01:37:29 -0400
Received: from gw.goop.org ([64.81.55.164]:49233 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbYGQFh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 01:37:29 -0400
Message-ID: <487EDA8B.1050203@goop.org>
Date: Wed, 16 Jul 2008 22:37:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       virtualization@lists.linux-foundation.org,
       Zachary Amsden <zach@vmware.com>, Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [PATCH] stopmachine: add stopmachine_timeout v2
References: <487B05CE.1050508@jp.fujitsu.com> <487D78A3.6050105@jp.fujitsu.com> <487DC943.5060202@goop.org> <487EBF1E.5030109@jp.fujitsu.com>
In-Reply-To: <487EBF1E.5030109@jp.fujitsu.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> sysctl.c already has many externs... but I can fix at least
> the above.
>   

Yeah, but it's an ugly pattern we'd rather not encourage.

>> I'll do a proper review soon.
>>     
>
> Is it better to postpone v4 until your comment comes?
>   

No.

J
