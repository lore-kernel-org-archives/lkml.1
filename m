Return-Path: <linux-kernel-owner+w=401wt.eu-S935383AbYEUP1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935383AbYEUP1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 11:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758363AbYEUP1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 11:27:14 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:59135 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757035AbYEUP1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 11:27:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nzkROP454r/pi0omFCfsRveADSntur0HDsDhOdlSr3ddTj0bHJgieqVlsv+eBGVqKkcjF+07+lsidvwJKZ0afAjK+KSRUmbrsedXHYMJ5cUrpVXe8dDjuQgbYB1Smh8UD2ktCaF3+MTknWL/FF1iN7pL0sdXQyMPhzv2YPVtdvU=
Message-ID: <84144f020805210826p27c1892bxd84098371e209c1e@mail.gmail.com>
Date: Wed, 21 May 2008 18:26:56 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Tarkan Erimer" <tarkan@netone.net.tr>
Subject: Re: Suggestion About Kernel Releases
Cc: "Mike Snitzer" <snitzer@gmail.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <48343C92.4090403@netone.net.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48341ED5.7060508@netone.net.tr>
	 <20080521063855.0bdb441c@infradead.org>
	 <84144f020805210648y43efb024w8e2f28e62894b1d@mail.gmail.com>
	 <48342B19.9040407@netone.net.tr>
	 <170fa0d20805210732s24f2c188i75ab2ab2dab5aeb5@mail.gmail.com>
	 <48343C92.4090403@netone.net.tr>
X-Google-Sender-Auth: 9a777990f80dc825
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 6:15 PM, Tarkan Erimer <tarkan@netone.net.tr> wrote:
> It is. As I described above : the "testX" series will change the things as
> producing more tested /stable releases. BTW, it should be much better to
> release less, trouble free kernels instead of releasing fast but fixing
> soon.

You keep saying that but it simply is not true. The more people we
have _waiting_ for a "stable" kernel to graduate from the "testing"
series, the less people we have actually _testing_ the kernel.

So it's probable that your suggestion actually makes the current
situation worse, not better.
