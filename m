Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbXKTRry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbXKTRry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 12:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbXKTRrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 12:47:47 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:55496 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbXKTRrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 12:47:46 -0500
Message-ID: <47431DB4.5060207@oracle.com>
Date: Tue, 20 Nov 2007 09:47:32 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de,
       torvalds@linux-foundation.org
Subject: Re: [PATCHv4 1/6] actual sys_indirect code
References: <200711200653.lAK6rEVB025878@devserv.devel.redhat.com> <20071120070414.GA543@elte.hu>
In-Reply-To: <20071120070414.GA543@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> cool patchset. Small nit, the series is not bisectable:

Yeah, in a few places.

Uli, this is super easy to test if you maintain the patches with guilt.
 With some easy scripting around guilt push you can verify that the
series builds as each patch is applied.

- z
