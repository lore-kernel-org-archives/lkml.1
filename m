Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbYJ0K0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbYJ0K0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 06:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbYJ0K0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 06:26:06 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:47297 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbYJ0K0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 06:26:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pPUizaSNiBAOQBs1HAi2+Gd2ND97x6HuCOg6UeAub2GlescYJeaAINZTyMQ7abO4vl
         ID0F1IJv6aJ3hQWXSUM52+gD0dGq2p6VYnDqq89PbB/691MXGEWZglsF6yWtdUyCXvj+
         p0jJGX8JIJ8xRFbrzVV0hR9iLrKPc9u4ZAGiw=
Message-ID: <c62985530810270326v79528ca9ne88c2c3c9da6558c@mail.gmail.com>
Date: Mon, 27 Oct 2008 11:26:01 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH][RESEND] ftrace: Add a script to produce a hierarchical view of a function trace
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081027100148.GB8116@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4904DF39.9070203@gmail.com>
	 <alpine.DEB.1.10.0810261903110.26269@gandalf.stny.rr.com>
	 <490513D5.7080806@gmail.com> <20081027100148.GB8116@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/27 Ingo Molnar <mingo@elte.hu>:
> nice! Applied it to tip/tracing/ftrace. I've added Steve's Acked-by,


Thanks!


> and i've moved the script to scripts/tracing/ - now that we'll have a
> handful of utility scripts there we might as well separate it a bit
> more clearly from the usual body of kernel scripts.
>
> i think we should move the other utility scripts there too. (but not
> the recordmcount script - that is an infrastructure script, not a
> utility script)


Good idea, for example bootgraph.pl matches the case, if Arjan agrees.
