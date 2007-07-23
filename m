Return-Path: <linux-kernel-owner+w=401wt.eu-S932131AbXGWIPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbXGWIPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbXGWIPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:15:35 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52853 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbXGWIPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:15:33 -0400
Date: Mon, 23 Jul 2007 10:16:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use LDFLAGS_MODULE only for .ko links
Message-ID: <20070723081648.GB4644@uranus.ravnborg.org>
References: <20070723064235.GA4129@uranus.ravnborg.org> <20070723081208.088674D058D@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723081208.088674D058D@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 01:12:08AM -0700, Roland McGrath wrote:
> This replaces the "Move --build-id option" patch.
> 
> Thanks,
> Roland
> 
> ---
> 
> Sam Ravnborg pointed out that Documentation/kbuild/makefiles.txt already
> says this is what it's for.  This patch makes the reality live up to the
> documentation.  This fixes the problem of LDFLAGS_BUILD_ID getting into too
> many places.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

[I though have not had the possibility to actually test the thing].

	Sam
