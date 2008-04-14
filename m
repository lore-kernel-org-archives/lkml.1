Return-Path: <linux-kernel-owner+w=401wt.eu-S1766002AbYDNSis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766002AbYDNSis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760174AbYDNSik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:38:40 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:17779 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760013AbYDNSij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:38:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kIbLGMx0G1LkiK4D3qnlw6/s1S6Eu52cXl+4OvBAymBKnGJ/BLTd/s4mAGXNd3zqUVVpYziNrOPlWv4tVcac5cppEg+idozYKwr8l6FdUCJEUhQuwHfQLYzyDQbhShJ3wxHm0YsR1Z2Jnx1yZ39Qp6kJ2W1uel1oqW/dg8FTEaI=
Message-ID: <e2e108260804141138s4d8badbrf389134f6923ad46@mail.gmail.com>
Date: Mon, 14 Apr 2008 20:38:32 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: API documentation (was [PATCH] Replace completions with semaphores)
Cc: "Jonathan Corbet" <corbet@lwn.net>, "Matthew Wilcox" <matthew@wil.cx>,
       "Roland Dreier" <rdreier@cisco.com>, "Ingo Oeser" <ioe-lkml@rameria.de>,
       "Daniel Walker" <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@osdl.org>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1208194395.7129.13.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <16641.1208193124@vena.lwn.net> <1208194395.7129.13.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 7:33 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>  Books should only be used to obtain the general picture, any details
>  will be instantly-obsolete, esp at the pace Linux changes.
>
>  Most of the concepts from LDD3 are still valid, many of the details are
>  dead wrong.
>
>  Can't we make LDD4 a high level book, explcitly mentioning how people
>  should go about obtaining details? Like go ask on #kernelnewbies and the
>  sorts.
>
>  The thing I always tell #kernelnewbies people is to look at a related
>  driver (of course that kite doesn't always fly). Another good way to
>  learn stuff is to just read the implementation.
>
>  A 'trick' that is often useful is to look in git to see how something
>  was changed, provided you knew how to do it some time in the past.

What I remember from the first time I wrote a network driver is that
reading the chapter in LDD3 about network drivers was the fastest way
to get started. Learning how to write a network driver by reverse
engineering existing drivers would have required much more time. My
opinion is that mentioning all relevant details in a book makes sense.

Bart.
