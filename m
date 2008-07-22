Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbYGVCsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbYGVCsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 22:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbYGVCsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 22:48:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524AbYGVCsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 22:48:45 -0400
Date: Mon, 21 Jul 2008 22:41:00 -0400
From: Dave Jones <davej@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org
Subject: Re: Fix icom serial compile.
Message-ID: <20080722024100.GA23365@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org
References: <20080721211659.GA29106@redhat.com> <20080721221355.GD3472@redhat.com> <20080721230742.4649b94a@lxorguk.ukuu.org.uk> <20080722112538.03c06649.sfr@canb.auug.org.au> <20080722030519.7d0e5ee3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722030519.7d0e5ee3@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 03:05:19AM +0100, Alan Cox wrote:
 > > > NAK. Already in the ttydev tree but not yet gone to Linus
 > > 
 > > I have just sent a similar patch.   I have to ask why you sent only some
 > > of these patches since they were known to break some builds and you had
 > > the fix patches already ...
 > 
 > I sent the first batch only because some later stuff didnt apply and I
 > happen to believe in testing patches before sending them (something I
 > note certain other people clearly do after shitting the lot at Linus)

So what stopped you from just sending the two diffs already posted here
twice today ?  They're not dependant upon anything else, and the files
in questions haven't changed in months.

Leaving the tree broken, and NACKing attempts to fix it don't seem to be
particularly productive for anyone.

 > I spent the past two days travelling, and all the net time I could get
 > trying to get the patches merged and tested. Everyone and their
 > grandmother keep patching the tty code again and again. I just had
 > another go before bed - its now six pulls in a row someone has broken the
 > patches.
 > 
 > Quite frankly if you want to moan about the fact I've been working till
 > 4am trying to sort this mess out you can go see figure 1.

Please, less drama, more fixing.

	Dave

-- 
http://www.codemonkey.org.uk
