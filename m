Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbYAPPSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbYAPPSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 10:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbYAPPSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 10:18:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54190 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbYAPPSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 10:18:30 -0500
Date: Wed, 16 Jan 2008 16:18:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 0 of 4] x86: some more patches
Message-ID: <20080116151816.GA16397@elte.hu>
References: <patchbomb.1200435425@localhost> <478D4197.8060904@goop.org> <20080116142242.GA23993@elte.hu> <200801161544.15884.ak@suse.de> <20080116145427.GA640@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116145427.GA640@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


today's x86.git now has all the fixes included - can you confirm that it 
boots fine on your box?

	Ingo
