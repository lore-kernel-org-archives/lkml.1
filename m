Return-Path: <linux-kernel-owner+w=401wt.eu-S1759250AbYFMEtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbYFMEtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 00:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbYFMEtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 00:49:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54659 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbYFMEtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 00:49:21 -0400
Date: Fri, 13 Jun 2008 06:48:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, zippel@linux-m68k.org,
       sam@ravnborg.org, shai@scalex86.org
Subject: Re: [2.6.25 - stable] Fix Kconfig dependencies to prevent
	CONFIG_X86_VSMP from vanishing
Message-ID: <20080613044858.GC5427@elte.hu>
References: <20080613023348.GA6071@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613023348.GA6071@localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1578]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> I am including a trimmed down patch of 
> 823c248e7cc75b4f22da914b01f8e5433cff197e to fix CONFIG_VSMP as per 
> stable policy.  This was tested and found to fix the problem mentioned 
> above.  Please apply.

hm, but why did you trim it down? I'd suggest we use the full 
823c248e7cc75b4 patch because that's what had been tested upstream.

	Ingo
