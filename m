Return-Path: <linux-kernel-owner+w=401wt.eu-S1765994AbXHDTHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765994AbXHDTHl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 15:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765393AbXHDTHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 15:07:33 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:29497 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760280AbXHDTHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 15:07:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sZeO34DUoFqkmN91RDL9B7Wv7kZDrqRhkPRCkir3AmmEwWwnA5DTOVG3rFWDuKCcZlEbHzIbiUeYpQWEefzBRXC267Wrk8RwIOVGzXF6HOg/t6L3LNYuqcW4/cJwWYI7XQ6Aj+OKMLVqQRtgYap31zoeTLQW02WYIyfFoZCE/tI=
Message-ID: <9a8748490708041207t5ba8063s4a75eabc4c8db8b6@mail.gmail.com>
Date: Sat, 4 Aug 2007 21:07:31 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Rob Landley" <rob@landley.net>
Subject: Re: [PATCH 1/2] Group architecture Documentation under Documentation/arch.
Cc: "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Roland Dreier" <rdreier@cisco.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       linux-doc@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Paul Mundt" <lethal@linux-sh.org>
In-Reply-To: <200708041404.01264.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705222225.39949.rob@landley.net>
	 <200705230025.45007.rob@landley.net>
	 <Pine.LNX.4.64.0705230922580.19474@anakin>
	 <200708041404.01264.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/07, Rob Landley <rob@landley.net> wrote:
> Signed-off-by: Rob Landley <rob@landley.net>
> Amiga part Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
> Move architecture-specific Documentation into a common subdirectory.
>
...

I have only one complaint; I don't see an update to Documentation/00-INDEX


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
