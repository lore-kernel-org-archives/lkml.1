Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbXEBLwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbXEBLwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 07:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755112AbXEBLwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 07:52:53 -0400
Received: from ns2.suse.de ([195.135.220.15]:45867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092AbXEBLww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 07:52:52 -0400
From: Neil Brown <neilb@suse.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Date: Wed, 2 May 2007 21:52:08 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17976.31592.666183.353731@notabene.brown>
Cc: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, Valdis.Kletnieks@vt.edu,
       Andre Tomt <andre@tomt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: so ... what *are* candidates for removal?
In-Reply-To: message from Robert P. J. Day on Wednesday May 2
References: <Pine.LNX.4.64.0705011050080.11853@localhost.localdomain>
	<46375D1C.4050404@tomt.net>
	<10590.1178037443@turing-police.cc.vt.edu>
	<4637C04E.4070306@s5r6.in-berlin.de>
	<Pine.LNX.4.64.0705020418530.7102@localhost.localdomain>
	<46385EF8.8040005@s5r6.in-berlin.de>
	<alpine.DEB.0.98.0705020612290.9993@sigma.j-a-k-j.com>
	<Pine.LNX.4.64.0705020653560.7971@localhost.localdomain>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday May 2, rpjday@mindspring.com wrote:
> On Wed, 2 May 2007, John Anthony Kazos Jr. wrote:
> 
> argh.  the whole point of this discussion is to come to a *consensus*
> on what should be in that feature removal file.  there is no point in
> creating and submitting patches, either to update that file or remove
> kernel features, until enough people *agree*.
> 
> at the risk of being head-bangingly repetitive, that's what the wiki
> page is for:
> 
> http://fsdev.net/wiki/index.php?title=Stuff_to_be_removed
> 
> go.  read.  comment.  update.  add.  remove.  it's a wiki.  don't make
> me pull this car over and explain it.  :-)

Unfortunately, this community is not founded on the concept of
'wiki'.  It is founded on the concept of 'email'.  That is were most
discussions happen.

So if you want to start a discussion (and your topic certainly seems
relevant) I suspect you will get more participation if you keep it in
the mailing list.

So post a list of features that are apparently due for removal and ask
"can I actually get rid of these" (or whatever you want to ask).  and
then base on the response, do something else, maybe a revised list,
maybe a patch, maybe send it again in CAPITALS because nobody notice
when it was in lower-case :-)

Wiki's certainly have there place, but I don't think this is it.

NeilBrown
