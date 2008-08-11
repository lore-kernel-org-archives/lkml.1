Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbYHKXTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbYHKXTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 19:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbYHKXS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 19:18:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:41208 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbYHKXS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 19:18:57 -0400
Subject: Re: [PATCH 1/2] add phys_addr_t for holding physical addresses
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, ehabkost@redhat.com,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <48A0C519.6070708@goop.org>
References: <489B6B40.5050705@goop.org>
	 <20080807145648.ab3dfa90.akpm@linux-foundation.org>
	 <489B72C3.30603@goop.org>
	 <20080807162741.8dfcd336.akpm@linux-foundation.org>
	 <489B8908.2010007@goop.org>
	 <20080807170617.79ca3ce7.akpm@linux-foundation.org>
	 <48A0954E.20400@goop.org> <1218491896.8041.9.camel@pasglop>
	 <48A0B9EB.9020709@goop.org> <1218493925.8041.21.camel@pasglop>
	 <48A0C22D.2050400@goop.org> <1218495200.8041.23.camel@pasglop>
	 <48A0C519.6070708@goop.org>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 09:17:01 +1000
Message-Id: <1218496621.8041.29.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The resource_size_t situation is obscure.  I'd be happy to just remove 
> its config, use my patch and typedef phys_addr_t resource_size_t.

I have no objection there as far as powerpc is concerned.

Ben.

