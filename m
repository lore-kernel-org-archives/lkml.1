Return-Path: <linux-kernel-owner+w=401wt.eu-S1760891AbXGJQ0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760891AbXGJQ0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760387AbXGJQ0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:26:06 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:36915
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760226AbXGJQ0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:26:01 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: Documentation of kernel messages (Summary)
Date: Tue, 10 Jul 2007 12:25:31 -0400
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       gregkh@suse.de, pavel@ucw.cz, tim.bird@am.sony.com, gh@us.ibm.com,
       arjan@infradead.org, sam@ravnborg.org, jengelh@computergmbh.de,
       joe@perches.com, auke-jan.h.kok@intel.com, hansendc@us.ibm.com,
       davem@davemloft.net, Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       linux-doc@vger.kernel.org
References: <1181747217.29512.9.camel@localhost.localdomain> <200707091248.24994.rob@landley.net> <20070709183309.GH3492@stusta.de>
In-Reply-To: <20070709183309.GH3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707101225.32843.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 July 2007 14:33:09 Adrian Bunk wrote:
> On Mon, Jul 09, 2007 at 12:48:24PM -0400, Rob Landley wrote:
> >...
> > [regarding translated documentation]
> >
> > For my part, I can't _tell_ when a given translation is out of date
> > because I can't read it, and I certainly can't update it.  So I agree
> > with Eric and I'm linking to sites hosting kernel documentation in other
> > languages rather than hosting them myself.  I've got a good link to a
> > Japanese site, need to ping the contributors of the chinese documentation
> > and see if they have a site for it...
> >...
>
> Include the last git commit on this file in the translated document?
>
> This would also make it easier for a translator to update a document
> because a diff on the original document since the last translation would
> be trivial.

Ok, back up.

Let's look at _english_ documentation.

If you go to http://kernel.org/doc/ols you should find, nicely split up, all 
the OLS papers from 2002-2007.  By my count, there are 337 of them, totaling 
61.8 megabytes when they're split up like that.  Being PDFs, they don't 
compress all that well.

Which subset of these should be copied into the Documentation directory?  How 
do you update them?  This is the documentation from just ONE SOURCE.

And PDF isn't close to the worst of it: Linuxconf.au has lots of video, as 
does google video.  (I don't even have _english_ transcripts for those 
videos, which would be nice.)  Do you want to merge all of this into the 
kernel tarball as well?

How does this help keep anything up to date?

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
