Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbZCWRtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbZCWRtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 13:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZCWRtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 13:49:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:38668 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbZCWRtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 13:49:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ftom5nuRIji7b62n6UxO2Hoa+F0MbNjxbRQhKeoWkYljuei/yxSZxek7Mz5TcZN+rT
         0y58QV7SMSvRDi3RXl3D9u7PfW3ZM0+s5axywzYeTEsaTpgqsCMo1I+gwrFrQk1o/h91
         S5Bpih0fRxcaRKlf3zplyvP4Lt6pssydOj15U=
MIME-Version: 1.0
In-Reply-To: <20090323165639.GA6841@elte.hu>
References: <49AD3433.9000001@cn.fujitsu.com>
	 <1237794502.6313.21.camel@penberg-laptop>
	 <alpine.DEB.1.10.0903230931570.4095@qirst.com>
	 <20090323155938.GA27151@elte.hu>
	 <alpine.DEB.1.10.0903231234110.11796@qirst.com>
	 <20090323165639.GA6841@elte.hu>
Date: Mon, 23 Mar 2009 19:49:01 +0200
X-Google-Sender-Auth: 74850f28e706164e
Message-ID: <84144f020903231049o11de5287w7bdb5c28e866dafb@mail.gmail.com>
Subject: Re: [PATCH -mm 1/6] slab: introduce __kfree_rcu
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 6:56 PM, Ingo Molnar <mingo@elte.hu> wrote:
> Anyway, these are nuances and if you go strictly by what's minimally
> required by Documentation/CodingStyle you can stop a lot sooner than
> having to bother about such fine details. The original version was
> certainly acceptable - it's just that IMO Pekka was right that it
> can be done better.

Well, like I said, it was a minor nitpick, that's all. I would prefer
it the way I and Ingo suggested but if you don't want to change it,
that's fine as well.
