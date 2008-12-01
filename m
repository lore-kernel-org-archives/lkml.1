Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbYLAMwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbYLAMwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbYLAMwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:52:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55913 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbYLAMwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:52:05 -0500
Date: Mon, 1 Dec 2008 13:51:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, "Dr. David Alan Gilbert" <dave@treblig.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] documentation: local_ops fix on_each_cpu
Message-ID: <20081201125138.GB21534@elte.hu>
References: <20081201104638.GD25340@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081201104638.GD25340@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Dr. David Alan Gilbert (dave@treblig.org) wrote:
> [...]
> >  I noticed while looking at something else that the example in
> >  local_ops.txt still has the 4 operand on_each_cpu in the latest git;
> >  I don't know the rest of the code around there very well so I thought
> >  it best to mention it rather than post a patch.
> 
> Reported-by: Dr. David Alan Gilbert <dave@treblig.org>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Ingo Molnar <mingo@elte.hu>
> ---
>  Documentation/local_ops.txt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

applied to tip/core/urgent, thanks!

	Ingo
