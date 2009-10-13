Return-Path: <linux-kernel-owner+w=401wt.eu-S1761022AbZJMS7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761022AbZJMS7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 14:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbZJMS7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 14:59:20 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:34874 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbZJMS7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 14:59:19 -0400
Date: Tue, 13 Oct 2009 20:58:41 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [GIT PULL] kbuild fixes
Message-ID: <20091013185841.GC5249@merkur.ravnborg.org>
References: <20091011221818.GA2833@merkur.ravnborg.org> <4AD2EBC6.1000505@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD2EBC6.1000505@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 12:41:42PM +0400, Michael Tokarev wrote:
> Sam Ravnborg wrote:
>> Hi Linus.
>>
>> A few kbuild related fixes.
> []
>> - Fix use of echo -ne. Is caused issues for ubuntu (IIRC) users
>
> As has been discussed previously (and Sam has been CC'ed), the fix
> is still incorrect.

In the thread hpa asked for a patch at least twice.
Only after I submitted -fixes to Linus it shows up.

Bad timing.

And please - do not even think of asking me to do it.
You guys are the one that see the issue, who know how to fix it,
and knows how to check that the fix really works.

In other words - provide a patch next time you are asked to do so.

I'm off for much needed vacation rest of the week and
may rememeber to handle the patch when I get back...

	Sam
