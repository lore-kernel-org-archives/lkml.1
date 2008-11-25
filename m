Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbYKYW21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbYKYW21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 17:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYKYW2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 17:28:17 -0500
Received: from mail.atheros.com ([12.36.123.2]:46313 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbYKYW2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 17:28:16 -0500
Date: Tue, 25 Nov 2008 14:28:14 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bob Copeland <me@bobcopeland.com>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       "ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>,
       "bkuhn@softwarefreedom.org" <bkuhn@softwarefreedom.org>
Subject: Re: [ath5k-devel] License of changes to ath5k/ath9k
Message-ID: <20081125222814.GG5950@tesla>
References: <20081125210421.GF5950@tesla> <b6c5339f0811251329h1130fd4aladcbfda52f0542eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b6c5339f0811251329h1130fd4aladcbfda52f0542eb@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 01:29:55PM -0800, Bob Copeland wrote:
> On Tue, Nov 25, 2008 at 4:04 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > We'll keep using the ath5k Changes-licensed-under tag until we get
> > advice from SFLC if we have done enough to ensure this is no longer
> > necessary. For ath9k, if we are not sure if you have read the
> > "Developer's Certificate of Origin 1.1" we may ping you with an e-mail
> > just to be sure.
> 
> I don't consider any of my changes significant enough to confer copyright,
> so by my Signed-off-by, I agree that whatever license the file currently
> has is alright by me.  Even if the changes were significant, the previous
> holds.
> 
> However, if everyone + SFLC prefers that we strictly use
> Changes-licensed-under even if we don't claim copyright, then I'll
> happily add the tag generator script to a git commit hook :)

Sure, BTW I had created such a script a long time ago, the files just
need to be updated (so update them if you download this thingy):

http://www.kernel.org/pub/linux/kernel/people/mcgrof/scripts/ath5k-license.pl.txt

Understood.

  Luis
