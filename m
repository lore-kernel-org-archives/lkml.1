Return-Path: <linux-kernel-owner+w=401wt.eu-S965372AbXBUPdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965372AbXBUPdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 10:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965393AbXBUPde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 10:33:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:12981 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965379AbXBUPdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 10:33:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=JQRDJtK8oZode7EBVJyIwothtARvTBUk+0cfRRBl6A9dloJ4fz5jh/eWRGgI9cHkMxqOyekls4vp3WLVxP5KZZDZGm36giLE9i24mNBM/8AEGpWwxTe0LCWQrrL+s/GH+w3EoxFZHwfK02hW0CGX4PCPX/KN0tGDoH525lCykVI=
Message-ID: <84144f020702210733s4576076cw7e9a2257d28b278b@mail.gmail.com>
Date: Wed, 21 Feb 2007 17:33:31 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 02/29] mm: slab allocation fairness
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       "Thomas Graf" <tgraf@suug.ch>, "David Miller" <davem@davemloft.net>
In-Reply-To: <20070221144841.751839000@taijtu.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221144304.512721000@taijtu.programming.kicks-ass.net>
	 <20070221144841.751839000@taijtu.programming.kicks-ass.net>
X-Google-Sender-Auth: e1786e23c6840d63
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> [AIM9 results go here]

Yes please. I would really like to know what we gain by making the
slab even more complex.
