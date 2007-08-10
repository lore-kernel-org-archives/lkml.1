Return-Path: <linux-kernel-owner+w=401wt.eu-S937581AbXHJNhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937581AbXHJNhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 09:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765463AbXHJNhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 09:37:08 -0400
Received: from server009.webpack.hosteurope.de ([80.237.130.17]:35465 "EHLO
	server009.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756241AbXHJNhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 09:37:06 -0400
X-Greylist: delayed 1712 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Aug 2007 09:37:06 EDT
From: Daniel Exner <webmaster@dragonslave.de>
Reply-To: webmaster@dragonslave.de
To: Jiri Kosina <jikos@jikos.cz>
Subject: Re: EHCI Regression in 2.6.23-rc2
Date: Fri, 10 Aug 2007 15:08:20 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Stuart_Hayes@dell.com,
       linux-usb-devel@lists.sourceforge.net
References: <200708101045.57166.dex@dragonslave.de> <Pine.LNX.4.64.0708101125120.3948@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0708101125120.3948@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708101508.21389.webmaster@dragonslave.de>
X-bounce-key: webpack.hosteurope.de;webmaster@dragonslave.de;1186753026;1cce0843;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Fri, 10 Aug 2007, Daniel Exner wrote:
> > Please CC me, as I'm currently not subscribed to this list, thx.
>
> Please also don't forget to CC relevant people/lists when reporting bugs,
> thanks.
Guess its ok, now? Thanks anyway :)

> > After some serious hangs with 2.6.23-rc2 I did some bisects and this was
> > the result:
> > 196705c9bbc03540429b0f7cf9ee35c2f928a534 is first bad commit
> > commit 196705c9bbc03540429b0f7cf9ee35c2f928a534
> > Author: Stuart_Hayes@Dell.com <Stuart_Hayes@Dell.com>
> > Date:   Thu May 3 08:58:49 2007 -0700
>
> I guess that the patch attached to bug 8535 in kernel.org bugzilla --
> http://bugzilla.kernel.org/attachment.cgi?id=12228&action=view -- solves
> your issues, right?
Nope, this does _not_ fix my issue.

Anything else I could try, or some files you need?
I tried finding some clue in my logs, but without any results so far.

Greetings
Daniel Exner
