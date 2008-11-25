Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbYKYVEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbYKYVEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbYKYVEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:04:24 -0500
Received: from mail.atheros.com ([12.36.123.2]:24312 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbYKYVEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:04:23 -0500
Date: Tue, 25 Nov 2008 13:04:21 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <ath5k-devel@venema.h4ckr.net>, <ath9k-devel@venema.h4ckr.net>,
       <bkuhn@softwarefreedom.org>
Subject: License of changes to ath5k/ath9k
Message-ID: <20081125210421.GF5950@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a friendly reminder:

For those of you who have not read yet what "Signed-off-by" means,
specially those who are new to contributing to the Linux kernel on
linux-wireless I'd like to encourage you to go and review it and
read what this means. You can find it under Documentation/SubmittingPatches,
on the: "Developer's Certificate of Origin 1.1"

Specifically the part that mentions how you right to submit it under
the same open source license indicated in the file. This is
particularly important for ath5k/ath9k as these drivers do have
some files licensed the 3-clause BSD license (only in ath5k) and ISC license
(ath9k is completely ISC). In the future we would like to point the BSD
community and even Solaris (yeah they seem interested in such a driver
it seems) toward ath5k and ath9k updates for the latest updates on INI file
updates, and hardare access routines so we want to remove any
legal ambiguity with respect for them to be able to copy+paste code
(even though that's not likely what they'll do exactly, but this should
help).

Technically speaking there are also some enhancements that can come our
way towards that we can use towards our Windows driver too but
realistically this has been minimal so far. If you could use GPL
licensed drivers under Windows that would remove all this silly
ISC/BSD licening preferences but the real reason to this e-mail is
more towards helping the BSD / Solaris community out. Realistically
speaking you cannot also expect all OSes to be license compatible,
at least at this point :).

We have been using the Changes-licensed-under tag [1] for ath5k development
but for ath9k we tend to ask developers individually if they are willing
submit their changes and any future ath9k changes under the ISC. We keep
this for our records just in case you haven't read the Singed-off-by.
I think it'd be easier too if we ensure developers really read that document
too and ensure they understand it and also understood why are are doing this.

We'll keep using the ath5k Changes-licensed-under tag until we get
advice from SFLC if we have done enough to ensure this is no longer
necessary. For ath9k, if we are not sure if you have read the
"Developer's Certificate of Origin 1.1" we may ping you with an e-mail
just to be sure.

While you're at it please subscribe to the wireless.kernel.org
SubmittingPatches page so you can get updates in case there are changes
there.

Ps. Please do not open any can of worms here, this is just informational.

[1] http://wireless.kernel.org/en/developers/Documentation/SubmittingPatches#Changes-licensed-undertag

Thanks,

  Luis
