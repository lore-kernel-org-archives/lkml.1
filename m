Return-Path: <linux-kernel-owner+w=401wt.eu-S1760868AbXK1Mix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868AbXK1Mix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 07:38:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbXK1Mid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 07:38:33 -0500
Received: from khc.piap.pl ([195.187.100.11]:35641 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbXK1Mic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 07:38:32 -0500
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove CONFIG_EXPERIMENTAL
References: <20071125161631.GA21947@stusta.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 28 Nov 2007 13:38:30 +0100
In-Reply-To: <20071125161631.GA21947@stusta.de> (Adrian Bunk's message of "Sun, 25 Nov 2007 17:16:31 +0100")
Message-ID: <m3aboy4kah.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> writes:

> This patch removes the EXPERIMENTAL option and all dependencies on 
> EXPERIMENTAL because they are pointless.

Unfortunately I have to agree. The only think it does is confusing
users, when they forget to enable it.
-- 
Krzysztof Halasa
