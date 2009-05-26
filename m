Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbZEZTfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbZEZTfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 15:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757043AbZEZTfC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 15:35:02 -0400
Received: from web50101.mail.re2.yahoo.com ([206.190.38.29]:23793 "HELO
	web50101.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756966AbZEZTfA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 15:35:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=y/lcGwt3Gl5/7ZLF84V+tCS1iYuyYH+LtnN1egirtS+eQ4lf8fo/HBxwvKvoyU4L0njF8z6YpBVLIizBe+iXcXN4pNGmz2ttRnt0CN2e+a2BPRX2jUPz7honrH/xjYc6byJ81TJGhfqWoanmok5nHDi2Gy1XmTB+8tsu2J9ZAN0=;
Message-ID: <325725.59630.qm@web50101.mail.re2.yahoo.com>
X-YMail-OSG: BaUdXzcVM1nxWPI.lK5q9e_fdhiiWh.veoXCFuvMKMSLolrnmfSM8kJzHdZyAhDXQe5KWXLrb_0Xbjom6Y.2god1JUHbURga.CkYg.02XHqnI0rDZZH_Rn_i4cVJLNKlO8jAgvf8JTZqez0AKcUP078DTYA3fieARbm7QTxJyhA2uWpFOOs0BSqO96qvgbXcHMbTeLm.rcTzl3S8Nad7WUIw.BHTgfhWkyiPFwbuQyNgP1oLOlRunHQJfdEzk2GousCcNFxMdQb1LoHKg45SFcPpfjxiARhjtPJwMlyYtn9wSBfxacsMqelsEeB9w05lnQECl7leGs7LsbK6eA--
X-Mailer: YahooMailClassic/5.4.6 YahooMailWebService/0.7.289.10
Date: Tue, 26 May 2009 12:35:02 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 12/18] MAINTAINERS - Pair EDAC-E752X P: and M: entries
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Sat, 5/23/09, Joe Perches <joe@perches.com> wrote:

From: Joe Perches <joe@perches.com>
Subject: [PATCH 12/18] MAINTAINERS - Pair EDAC-E752X P: and M: entries
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Saturday, May 23, 2009, 8:37 PM

Entries should be P: name then M: email address

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Doug Thompson <dougthompson@xmission.com>


---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1bf74c9..2ae5a2e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1971,8 +1971,8 @@ F:    include/linux/edac.h
 
 EDAC-E752X
 P:    Mark Gross
-P:    Doug Thompson
 M:    mark.gross@intel.com
+P:    Doug Thompson
 M:    dougthompson@xmission.com
 L:    bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:    bluesmoke.sourceforge.net
-- 
1.6.3.1.10.g659a0.dirty

