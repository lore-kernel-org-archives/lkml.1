Return-Path: <linux-kernel-owner+w=401wt.eu-S1760628AbYDNNzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628AbYDNNzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 09:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbYDNNy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 09:54:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:55925 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755814AbYDNNyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 09:54:55 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX196IYNSsJ16fV9r4ZGM8gUm3497naXME/LQAQtlRe
	TvLmZkRRon7/uo
Subject: Re: [PATCH 00/13] Re: Scalability requirements for sysv ipc
From: Mike Galbraith <efault@gmx.de>
To: Nadia.Derbey@bull.net
Cc: manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       peterz@infradead.org, xemul@openvz.org
In-Reply-To: <20080411161702.460410000@bull.net>
References: <20080411161702.460410000@bull.net>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 15:54:36 +0200
Message-Id: <1208181276.4697.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-04-11 at 18:17 +0200, Nadia.Derbey@bull.net wrote:

> Mike, can you try to run it on your victim: I had such a hard time building
> this patch, that I couldn't re-run the test on my 8-core with this new
> version. So the last results I have are for 2.6.25-rc3-mm1.

I wedged the patches into 2.6.25.git.  5 second psem numbers for quad.

4071994
8342256
11864126
15425507

	-Mike

