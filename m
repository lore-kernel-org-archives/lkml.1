Return-Path: <linux-kernel-owner+w=401wt.eu-S934076AbXK3Nfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934076AbXK3Nfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 08:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbXK3NfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 08:35:20 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37235 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbXK3NfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 08:35:19 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Serge Hallyn <serue@us.ibm.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Pavel Emelyanov <xemul@openvz.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/4] Sysctl namespace support
References: <4742C73C.3010904@openvz.org>
	<m1odddc5mf.fsf@ebiederm.dsl.xmission.com>
	<20071130125627.GH26848@gondor.apana.org.au>
Date: Fri, 30 Nov 2007 06:25:25 -0700
In-Reply-To: <20071130125627.GH26848@gondor.apana.org.au> (Herbert Xu's
	message of "Fri, 30 Nov 2007 23:56:27 +1100")
Message-ID: <m1bq9bamre.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Thu, Nov 29, 2007 at 10:40:24AM -0700, Eric W. Biederman wrote:
>> 
>> Herbert we need this infrastructure most in net-2.6.25 (as not having
>> it is a current bottleneck to further development of the network
>> namespace) so these patches are against net-2.6.25.
>
> I've applied them all to net-2.6.25 with Andrew's fixes included.
> Thanks Eric.

Welcome, and thanks.

I will see about taking advantage of this shortly.

Eric
