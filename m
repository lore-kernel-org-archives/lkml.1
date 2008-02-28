Return-Path: <linux-kernel-owner+w=401wt.eu-S1765544AbYB1UA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765544AbYB1UA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764084AbYB1TzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:55:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54385 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764544AbYB1TzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:55:22 -0500
Date: Thu, 28 Feb 2008 20:54:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, hidave.darkstar@gmail.com,
       akpm@linux-foundation.org, fzu@wemgehoertderstaat.de, ego@in.ibm.com,
       dipankar@in.ibm.com, niv@us.ibm.com, dvhltc@us.ibm.com
Subject: Re: [PATCH] Remove never-migrates assumption from
	rcu_process_callbacks()
Message-ID: <20080228195454.GB29720@elte.hu>
References: <20080228002110.GA20091@linux.vnet.ibm.com> <20080228195107.GA31203@linux.vnet.ibm.com> <20080228195309.GA29720@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228195309.GA29720@elte.hu>
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

> i've got the patch below queued up already - same thing, right?

oh, not the same thing - just looking very similar.

queued up the second patch too :-)

	Ingo
