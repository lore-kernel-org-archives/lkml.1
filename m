Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbYBXOeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbYBXOeL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 09:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbYBXOd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 09:33:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45213 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbYBXOd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 09:33:57 -0500
Date: Sun, 24 Feb 2008 15:33:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, John Levon <levon@movementarian.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       sandmann@redhat.com, tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-ID: <20080224143318.GA16879@elte.hu>
References: <20080219123756.6261c13c@laptopd505.fenrus.org> <20080223001130.d8922136.akpm@linux-foundation.org> <20080223113724.GB31304@elte.hu> <20080223135335.GA28464@totally.trollied.org.uk> <20080224131001.GA7150@mit.edu> <20080224134421.GA31845@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080224134421.GA31845@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> I'm the one to make sure that patches for useful userspace tools that 
> get submitted to me eventually go upstream, one way or another. 

just to make it clear: that "one way or another" very much includes the 
possibility that sysprof is modified to make use of the oprofile APIs - 
i.e. no kernel patch needed at all.

	Ingo
