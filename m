Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbYEDNAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbYEDNAu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 09:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYEDNAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 09:00:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:35592 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYEDNAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 09:00:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=UPgtNJNvJvj9ZCjbqimPXcLv0qX641ofvIK7o4Qq+71/ODhWFwE75ixJX4rxCCFkJ7zlh17DMIHa1JRhPjbQJuVrPTyDen5FvwObkgpZQdqzgIUx/qvrIuOY1DgBc7tCfA06aexXXQBGFWRvcqzDzNSjtSktC5/+C95CRnrK0zg=
Message-ID: <84144f020805040600t32fb6170jf8a1efe0d8e382fd@mail.gmail.com>
Date: Sun, 4 May 2008 16:00:37 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Rene Herman" <rene.herman@keyaccess.nl>
Subject: Re: RFC: starting a kernel-testers group for newbies
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
In-Reply-To: <481DB004.5090109@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080429.190352.137408408.davem@davemloft.net>
	 <200804302136.58005.rjw@sisk.pl>
	 <20080430131537.1f7a0914.akpm@linux-foundation.org>
	 <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
	 <20080501003125.GM29330@cs181133002.pp.htv.fi>
	 <20080430000338.50548884@infradead.org>
	 <20080501011346.522f9846.akpm@linux-foundation.org>
	 <20080430071526.1bce202c@infradead.org>
	 <481DB004.5090109@keyaccess.nl>
X-Google-Sender-Auth: 12192415e02355de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 4, 2008 at 3:45 PM, Rene Herman <rene.herman@keyaccess.nl> wrote:
>  On that note, I'd really like to see better binary availability of cross
> compilers. While it's improved over the last few years mostly due to the
> crossgcc stuff it's still a pain. Ideally, they would be available through
> the distribution package manager even but failing that some dedicated place
> on kernel.org with x86->lots and some of the more widely used other
> combinations would quite definitely be good. Perhaps not really directly
> relevant to this thread as such, but still good.
>
>  Andrew maintain{s,ed} a number of them at
>
>  http://userweb.kernel.org/~akpm/cross-compilers/
>
>  But as you see, most of the stuff there is really old again...

You're most welcome to help out Vegard to do this:

http://www.kernel.org/pub/tools/crosstool/
