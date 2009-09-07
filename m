Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbZIGSee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbZIGSee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 14:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbZIGSec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 14:34:32 -0400
Received: from mail.perches.com ([173.55.12.10]:1030 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193AbZIGSe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 14:34:29 -0400
Subject: [PATCH V2] MAINTAINERS: Add Atheros Linux wireless drivers home
 page
From: Joe Perches <joe@perches.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Len Widra <Len.Widra@atheros.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Nick Kossifidis <mickflemm@gmail.com>,
       Bob Copeland <me@bobcopeland.com>, Greg KH <greg@kroah.com>,
       Stephen Chen <Stephen.Chen@atheros.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Senthil Balasubramanian <senthilkumar@atheros.com>,
       Jiri Slaby <jirislaby@gmail.com>, Jouni Malinen <jmalinen@atheros.com>,
       Sujith Manoharan <Sujith.Manoharan@atheros.com>,
       Vasanthakumar Thiagarajan <vasanth@atheros.com>,
       Senthil Balasubramanian <senthilkumar@atheros.com>
In-Reply-To: <43e72e890909061226w743e84e6p17fe0d097316678e@mail.gmail.com>
References: <43e72e890909031554v1343bcfdu8ed6e23d0b1df832@mail.gmail.com>
	 <1252259950.9660.179.camel@Joe-Laptop.home>
	 <43e72e890909061226w743e84e6p17fe0d097316678e@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 11:34:30 -0700
Message-Id: <1252348470.3394.30.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-06 at 12:26 -0700, Luis R. Rodriguez wrote:
> On Sun, Sep 6, 2009 at 10:59 AM, Joe Perches<joe@perches.com> wrote:
> > On Thu, 2009-09-03 at 15:54 -0700, Luis R. Rodriguez wrote:
> >> I'm pleased to announce the new home page to Atheros Linux wireless drivers:
> >> http://wireless.kernel.org/en/users/Drivers/Atheros
> > Perhaps add this to MAINTAINERS?
> Fine by me, except ath5k and ath9k also have their own respective page
> so those can also be added.

(cc's trimmed and maintainers added)

Perhaps this instead:

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 8dca9d8..b0ef9c7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -876,6 +876,7 @@ M:	"Luis R. Rodriguez" <lrodriguez@atheros.com>
 M:	Bob Copeland <me@bobcopeland.com>
 L:	linux-wireless@vger.kernel.org
 L:	ath5k-devel@lists.ath5k.org
+W:	http://wireless.kernel.org/en/users/Drivers/ath5k
 S:	Maintained
 F:	drivers/net/wireless/ath/ath5k/
 
@@ -887,6 +888,7 @@ M:	Vasanthakumar Thiagarajan <vasanth@atheros.com>
 M:	Senthil Balasubramanian <senthilkumar@atheros.com>
 L:	linux-wireless@vger.kernel.org
 L:	ath9k-devel@lists.ath9k.org
+W:	http://wireless.kernel.org/en/users/Drivers/ath9k
 S:	Supported
 F:	drivers/net/wireless/ath/ath9k/
 



