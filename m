Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbYANPwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbYANPwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 10:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYANPw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 10:52:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36185 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbYANPw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:52:27 -0500
Date: Mon, 14 Jan 2008 16:52:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] serverworks: IRQ routing needs no _p
Message-ID: <20080114155205.GB14177@elte.hu>
References: <20080111181434.3dec6206@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111181434.3dec6206@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> I can find no reason for the _p on the serverworks IRQ routing logic, 
> and a review of the documentation contains no indication that any such 
> delay is needed so lets try this

thanks, applied to x86.git.

	Ingo
