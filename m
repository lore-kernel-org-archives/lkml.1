Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438Ab0A2LGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab0A2LGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 06:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539Ab0A2LGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 06:06:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59450 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab0A2LGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 06:06:06 -0500
Subject: Re: [PATCH 07/10] bitops: Provide compile time HWEIGHT{8,16,32,64}
From: Peter Zijlstra <peterz@infradead.org>
To: John Kacur <jkacur@redhat.com>
Cc: eranian@google.com, fweisbec@gmail.com, paulus@samba.org, mingo@elte.hu,
       davem@davemloft.net, robert.richter@amd.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <520f0cf11001290232p38140fb2sa5da1b7f8e2704cc@mail.gmail.com>
References: <20100122155044.391857484@chello.nl>
	 <20100122155535.797688466@chello.nl>
	 <520f0cf11001290232p38140fb2sa5da1b7f8e2704cc@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jan 2010 12:05:49 +0100
Message-ID: <1264763149.4283.2215.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 11:32 +0100, John Kacur wrote:
> 
> I like it. Maybe provide a comment that this provides the Hamming weight, it
> took me a second to realize what this was.

its called _H_weight for crying out loud.

