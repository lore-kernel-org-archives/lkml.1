Return-Path: <linux-kernel-owner+w=401wt.eu-S1752375AbZCREEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbZCREEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 00:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbZCREEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 00:04:09 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:38121
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbZCREEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 00:04:07 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Greg Ungerer <gerg@snapgear.com>
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
Date: Tue, 17 Mar 2009 23:03:58 -0500
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; x86_64; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       linux-next@vger.kernel.org, linux-m68k@vger.kernel.org
References: <200903120437.03837.rob@landley.net> <200903161521.00036.rob@landley.net> <49BEDC75.1080704@snapgear.com>
In-Reply-To: <49BEDC75.1080704@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903172304.00157.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 March 2009 18:10:45 Greg Ungerer wrote:
> >>    git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git
> >> fix-includes
...
> Did you get the "fix-includes" branch?

Quite possibly not.  (I'm not a git person.)

I did a "git clone git://blah fix-includes" of the branch you gave a URL to, 
checked for tags and saw nothing particularly interesting, did a log -v and 
exported an archive of the most recent commit, and built it.

(Just tried it again with the same result.)

What _should_ I have done?

Rob
