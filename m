Return-Path: <linux-kernel-owner+w=401wt.eu-S1759626AbYEVEv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbYEVEv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 00:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbYEVEvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 00:51:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:61016 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbYEVEvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 00:51:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NG71mwxm6j+L8BBI3L1qwPeIdZXuNbSZ+BRg+TU4I9dmAo2+p+MF/B0BGIYz1xp9tkuFtwZllOjM1pnappTEjr23kf/tUktQVzZUk7Qcl1v19hN7aefPjCAjhIDKWEQLbdMPUVV1gyaehVUg0uOZ8GhMqL1fA1OSEeRZt72Joc0=
Message-ID: <aa79d98a0805212151y22190e09kddfde7514c184c26@mail.gmail.com>
Date: Thu, 22 May 2008 08:51:44 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: CFD: linux-wanking@vger.kernel.org (was [PATCH] Standard indentation of arguments)
Cc: "Jonathan Corbet" <corbet@lwn.net>, rdunlap@xenotime.net, tytso@mit.edu,
       hch@infradead.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <9a8748490805211646s5ef93f8ey43ebbc7746fb1a3b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490805211306l50b8411ax4462be18c94ca065@mail.gmail.com>
	 <32279.1211401651@vena.lwn.net>
	 <9a8748490805211337q1e7ceab7i80e4820c46f8171b@mail.gmail.com>
	 <9a8748490805211646s5ef93f8ey43ebbc7746fb1a3b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 3:46 AM, Jesper Juhl <jesper.juhl@gmail.com> wrote:
[...]
>
> Try to stay away from doing pointless work, like just fixing up the
> coding style in a file, reformatting comments etc - it's not worth the
> effort and your patch is likely to be rejected...
[...]

Quite good document, I must say. Jesper, I think that part of
text (what to stay away from) *must* be marked special somehow.
I'm not sure if every newbie would read this document before sending
patch but we will be able to say "Hey, we warned you not the once
about useless work! Don't do that again!" (maybe it should be
even CAPITALIZED)
