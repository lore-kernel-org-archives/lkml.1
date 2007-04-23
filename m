Return-Path: <linux-kernel-owner+w=401wt.eu-S1161386AbXDWLbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161386AbXDWLbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 07:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161451AbXDWLbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 07:31:50 -0400
Received: from vsmtp2.tin.it ([212.216.176.222]:57230 "EHLO vsmtp2.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161386AbXDWLbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 07:31:49 -0400
Date: Mon, 23 Apr 2007 13:31:09 +0200 (CEST)
From: l.genoni@oltrelinux.com
X-X-Sender: venom@Phoenix.oltrelinux.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: William Heimbigner <icxcnika@mar.tar.cc>, Rik van Riel <riel@redhat.com>,
       Eric Hopper <hopper@omnifarious.org>, linux-kernel@vger.kernel.org
Subject: Re: Question about Reiser4
In-Reply-To: <20070423010445.454eda63.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704231328030.19195@Phoenix.oltrelinux.com>
References: <20070423020046.GA28477@omnifarious.org> <462C2E5B.1080008@redhat.com>
 <Pine.LNX.4.64.0704230353000.25153@server.thyself> <462C4858.3050006@redhat.com>
 <Pine.LNX.4.64.0704230555020.25153@server.thyself> <462C4D32.4000909@redhat.com>
 <Pine.LNX.4.64.0704230611430.25153@server.thyself> <462C5034.9090403@redhat.com>
 <Pine.LNX.4.64.0704230640540.25153@server.thyself>
 <20070423010445.454eda63.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is something I don't understand...
It seems there is a maintainer, namesys people, which is what I was 
supposing, and probably it is the most qualified one for reiser4,

but it also seems you imply that they are not interested right now in 
kernel inclusion, since they are not asking "in this moment" for it.

Do I misunderstand? To me it seems they are implicitally interested in 
kernel inclusion since they are maintaining the code, and they alredy 
asked for this.

regards

Luigi
On Mon, 23 Apr 2007, Andrew Morton wrote:

>
> The namesys engineers continue to maintain reiser4 and I continue to
> receive patches for it.
>
> Right now I'd say that the main blockages for reiser4 are a) the developers
> aren't presently asking for inclusion (afaik) and b) lack of reviewing
> effort from other kernel developers.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
