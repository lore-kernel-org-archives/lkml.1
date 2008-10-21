Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbYJUMTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbYJUMTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYJUMTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:19:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47540 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbYJUMTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:19:44 -0400
Date: Tue, 21 Oct 2008 14:19:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Uwe Hermann <uwe@hermann-uwe.de>
Subject: Re: [PATCH] doc/x86: update file locations and 00-INDEX
Message-ID: <20081021121936.GB17108@elte.hu>
References: <48FD1374.9090504@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FD1374.9090504@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> A few Doc/x86/ files were moved, so account for that.
> Update Doc/x86/00-INDEX file.

we already had this patch in tip/x86/doc, and i resolved this conflict 
yesterday. (it was easy) Generally we'll handle all conflicts once we've 
picked up patches, no need to resend.

	Ingo
