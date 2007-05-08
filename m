Return-Path: <linux-kernel-owner+w=401wt.eu-S1032170AbXEHVKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032170AbXEHVKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967923AbXEHVKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:10:21 -0400
Received: from khc.piap.pl ([195.187.100.11]:48738 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967854AbXEHVKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:10:20 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Rientjes <rientjes@google.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] doc: volatile considered evil
References: <516386418.20070501080839@gmail.com>
	<20070430235642.e576e917.akpm@linux-foundation.org>
	<20070508121404.17bd97a6.randy.dunlap@oracle.com>
	<alpine.DEB.0.99.0705081217180.12908@chino.kir.corp.google.com>
	<m3k5vj2iha.fsf@maximus.localdomain> <4640E62D.8060704@goop.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 08 May 2007 23:10:17 +0200
In-Reply-To: <4640E62D.8060704@goop.org> (Jeremy Fitzhardinge's message of "Tue, 08 May 2007 14:05:49 -0700")
Message-ID: <m38xbz9g3q.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> No, David means that "asm volatile (...)" is meaningful and OK to use.

Ok, I mistook that.
-- 
Krzysztof Halasa
