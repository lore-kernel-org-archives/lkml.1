Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbYI3U5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbYI3U5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 16:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbYI3U5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 16:57:09 -0400
Received: from twin.jikos.cz ([213.151.79.26]:48798 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbYI3U5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 16:57:08 -0400
Date: Tue, 30 Sep 2008 22:55:40 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Rodolfo Giometti <giometti@enneenne.com>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Alessandro Rubini <ar@gnudd.com>,
       Alessandro Rubini <rubini@vision.unipv.it>
Subject: Re: About the maintainer of "MOUSE AND MISC DEVICES"
In-Reply-To: <20080930153708.GX18732@tekkaman>
Message-ID: <Pine.LNX.4.64.0809302248150.2307@twin.jikos.cz>
References: <20080930153708.GX18732@tekkaman>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008, Rodolfo Giometti wrote:

> I just wrote to Alessandro in order to have some suggestions about a 
> misc device I wish to propose to this list, but he told me that he wants 
> leave his maintanership.
> So which is the person should I send my requests about misc devices?
> He also asked to me to propose to this list a "patch" to remove him
> from the MAINTANERS file... if so the new entry should be:
> MOUSE AND MISC DEVICES [GENERAL]
> L:      linux-kernel@vger.kernel.org
> S:      Maintained

I in fact never understood what this maintainers entry meant ... what is 
the device in question here?

Anyway, something for Andrew



From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] remove "Mouse and Misc devices" from MAINTAINERS

remove "Mouse and Misc devices" from MAINTAINERS

Alessandro himself claims that he gives up maintainership, and to be 
frank, I don't have a clue what this entry is about.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

--- 

 MAINTAINERS |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3596d17..3d9635f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2818,12 +2818,6 @@ M:	ppisa@pikron.com
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 
-MOUSE AND MISC DEVICES [GENERAL]
-P:	Alessandro Rubini
-M:	rubini@ipvvis.unipv.it
-L:	linux-kernel@vger.kernel.org
-S:	Maintained
-
 MOXA SMARTIO/INDUSTIO/INTELLIO SERIAL CARD
 P:	Jiri Slaby
 M:	jirislaby@gmail.com
