Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbZEEPfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbZEEPfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 11:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbZEEPfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 11:35:33 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56782 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbZEEPfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 11:35:32 -0400
Date: Tue, 5 May 2009 08:35:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, tridge@samba.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Steve French <smfrench@gmail.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090505153527.GA6890@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090504153815.GB6740@linux.vnet.ibm.com> <20090504155505.GA8822@parisc-linux.org> <20090504161024.GC6740@linux.vnet.ibm.com> <20090504162252.GB8822@parisc-linux.org> <20090504221208.GB29402@kroah.com> <20090505020149.GE8822@parisc-linux.org> <20090505021121.GA6982@linux.vnet.ibm.com> <20090505021853.GF8822@parisc-linux.org> <20090505033442.GB6982@linux.vnet.ibm.com> <74785.1241510758@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74785.1241510758@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 04:05:58AM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 04 May 2009 20:34:42 PDT, "Paul E. McKenney" said:
> 
> > I am more than happy to let you search the case law on this one.
> 
> Ya know, it's that same "I'll let your lawyers rediscover the stuff that mine
> already found" issue that's making this thread a pain.

My apologies for the pain, however, Matthew said that he "never trusted
advice from IBM laywers", so there didn't seem to be any point in
consulting them.

> Case saying (C) *possibly* sufficient (ruling 'c-in-hexagon' was sufficient):
> Videotronics v. Bend Electronics, 586 F.Supp. 478, 481 (D. Nev. 1984)
> 
> Case saying it might not be:
> Forry v. Neundorfer, 837 F.2d 259, 266 (6th Cir., 1988)
> 
> Neundorfer says:
> 
> "Videotronics, Inc. v. Bend Electronics, 586 F.Supp. 478 (D.Nev.1984) held that
> a letter "C" enclosed within a hexagon met the statutory requirements, but
> suggested in dicta that the symbol "(C)" might not be sufficient because
> parentheses, unlike a hexagon or a circle, would not completely enclose the
> "C". Id. at 481. However, if a "C" in a hexagon is sufficient, an argument
> exists that a "C" in parentheses is sufficient. Defendants here had actual
> notice of copyright. The trial of this action may provide a better record on
> which to finally decide whether the symbol "(C)" is sufficiently similar to a
> "C" in a circle to serve as notice of a copyright. Plaintiff is apparently now
> using the "C" in a circle. It may therefore be entitled to rely on 405(a)(2)
> even if the earlier symbol was not sufficient."
> 
> Clear as mud, unless you have a more recent cite. :)

http://books.google.com/books?id=6je0tPcGMzYC&pg=PT822&lpg=PT822&dq=Videotronics+v.+Bend+Electronics,+586+F.Supp.+478,+481+(D.+Nev.+1984)&source=bl&ots=ccxO5np_uQ&sig=Q0wj4k5uCpMiZybAQe12JlHhh0A&hl=en&ei=Z1kASu2ZJ8eLtgehupyNBw&sa=X&oi=book_result&ct=result&resnum=2#PPT822,M1

Dated 2005, cites a 1988 case in footnote 28.  Also claims that:
Copyright Office II Compendium of Copyright Office Practices lists
acceptable variants to the C in a circle, including "(c)".

But this is a USA publication.  Perhaps Matthew is thinking in terms of
some other geography.  And perhaps things have changed since 2005.

							Thanx, Paul
