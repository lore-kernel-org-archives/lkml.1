Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbXJaSJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbXJaSJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 14:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbXJaSIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 14:08:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:65092 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbXJaSIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 14:08:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=niSpYNgMe0V3x3eTXzb75TmDabmZE7W8q/03sSMCBpMNyAdSDVaubDCdwA1krdPGRJ+CiAyzCeqcLvM9CSdCtHY3+1k4IVrAFDTAYOhreXJKg/9xX6BaL4BvQJHdIEsCgE054Yn8Hbqap33hQLRNDizP0yFVz05iUUt7PiXPDKE=
Message-ID: <4728C4AF.5010101@googlemail.com>
Date: Wed, 31 Oct 2007 19:08:47 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: netdev <netdev@vger.kernel.org>, chessman@tux.org
Subject: [PATCH] tlan list is subscribers-only 
References: <4728C266.2010600@googlemail.com>
In-Reply-To: <4728C266.2010600@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

...

Your mail to 'Tlan-devel' with the subject

    drivers/net/tlan question

Is being held until the list moderator can review it for approval.

The reason it is being held:

    Post by non-member to a members-only list

...

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4a26f83..6a116f3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3729,7 +3729,7 @@ S:	Maintained
 TLAN NETWORK DRIVER
 P:	Samuel Chessman
 M:	chessman@tux.org
-L:	tlan-devel@lists.sourceforge.net
+L:	tlan-devel@lists.sourceforge.net (subscribers-only)
 W:	http://sourceforge.net/projects/tlan/
 S:	Maintained
 
