Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbYADJMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbYADJMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 04:12:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbYADJLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 04:11:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52052 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938AbYADJLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 04:11:54 -0500
Date: Fri, 4 Jan 2008 10:11:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [9/16] Remove CPU capabitilites printks on i386
Message-ID: <20080104091145.GH28740@elte.hu>
References: <20080103442.621670000@suse.de> <20080103154223.3AAE814DDB@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103154223.3AAE814DDB@wotan.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0013]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> I don't know of any case where they have been useful and they look 
> ugly.

yeah - and KERN_DEBUG is rarely useful anyway.

	Ingo
