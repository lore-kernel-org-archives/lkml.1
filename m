Return-Path: <linux-kernel-owner+w=401wt.eu-S1758664AbYG2O75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbYG2O75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 10:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbYG2O7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 10:59:42 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:10985 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbYG2O7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 10:59:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=jS8f10aH6mIWZD+vtt3wNhB/SFsiPVz2QbLvucF76G910xtnBo0hw/W8EEXcXXFf2x
         iG4qHydebj836Rbevhaix/91ARfZAOuKogyH7LfzaGPUALCtvCShDnZkw3xvbQfSJ3Oi
         B7zu77b1xFzXIXA5deT7D1BgQH+Vthf6z1mvc=
From: Jon Smirl <jonsmirl@gmail.com>
Subject: [PATCH] Remove the .mailmap file
To: linux-kernel@vger.kernel.org
Date: Tue, 29 Jul 2008 10:59:34 -0400
Message-ID: <20080729145934.20023.27294.stgit@terra>
User-Agent: StGIT/0.14.3.173.g2e37
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the .mailmap file since fixing it is viewed as a privacy violation

Signed-off-by: Jon Smirl <jonsmirl@gmail.com>
---

 .mailmap |   99 --------------------------------------------------------------
 1 files changed, 0 insertions(+), 99 deletions(-)
 delete mode 100644 .mailmap

diff --git a/.mailmap b/.mailmap
deleted file mode 100644
index 7260842..0000000
--- a/.mailmap
+++ /dev/null
@@ -1,99 +0,0 @@
-#
-# This list is used by git-shortlog to fix a few botched name translations
-# in the git archive, either because the author's full name was messed up
-# and/or not always written the same way, making contributions from the
-# same person appearing not to be so or badly displayed.
-#
-# repo-abbrev: /pub/scm/linux/kernel/git/
-#
-
-Aaron Durbin <adurbin@google.com>
-Adam Oldham <oldhamca@gmail.com>
-Adam Radford <aradford@gmail.com>
-Adrian Bunk <bunk@stusta.de>
-Alan Cox <alan@lxorguk.ukuu.org.uk>
-Alan Cox <root@hraefn.swansea.linux.org.uk>
-Aleksey Gorelov <aleksey_gorelov@phoenix.com>
-Al Viro <viro@ftp.linux.org.uk>
-Al Viro <viro@zenIV.linux.org.uk>
-Andreas Herrmann <aherrman@de.ibm.com>
-Andrew Morton <akpm@osdl.org>
-Andrew Vasquez <andrew.vasquez@qlogic.com>
-Andy Adamson <andros@citi.umich.edu>
-Arnaud Patard <arnaud.patard@rtp-net.org>
-Arnd Bergmann <arnd@arndb.de>
-Axel Dyks <xl@xlsigned.net>
-Ben Gardner <bgardner@wabtec.com>
-Ben M Cahill <ben.m.cahill@intel.com>
-Björn Steinbrink <B.Steinbrink@gmx.de>
-Brian Avery <b.avery@hp.com>
-Brian King <brking@us.ibm.com>
-Christoph Hellwig <hch@lst.de>
-Corey Minyard <minyard@acm.org>
-David Brownell <david-b@pacbell.net>
-David Woodhouse <dwmw2@shinybook.infradead.org>
-Domen Puncer <domen@coderock.org>
-Douglas Gilbert <dougg@torque.net>
-Ed L. Cashin <ecashin@coraid.com>
-Evgeniy Polyakov <johnpol@2ka.mipt.ru>
-Felipe W Damasio <felipewd@terra.com.br>
-Felix Kuhling <fxkuehl@gmx.de>
-Felix Moeller <felix@derklecks.de>
-Filipe Lautert <filipe@icewall.org>
-Franck Bui-Huu <vagabon.xyz@gmail.com>
-Frank Zago <fzago@systemfabricworks.com>
-Greg Kroah-Hartman <greg@echidna.(none)>
-Greg Kroah-Hartman <gregkh@suse.de>
-Greg Kroah-Hartman <greg@kroah.com>
-Henk Vergonet <Henk.Vergonet@gmail.com>
-Henrik Kretzschmar <henne@nachtwindheim.de>
-Herbert Xu <herbert@gondor.apana.org.au>
-Jacob Shin <Jacob.Shin@amd.com>
-James Bottomley <jejb@mulgrave.(none)>
-James Bottomley <jejb@titanic.il.steeleye.com>
-James E Wilson <wilson@specifix.com>
-James Ketrenos <jketreno@io.(none)>
-Jean Tourrilhes <jt@hpl.hp.com>
-Jeff Garzik <jgarzik@pretzel.yyz.us>
-Jens Axboe <axboe@suse.de>
-Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
-John Stultz <johnstul@us.ibm.com>
-Juha Yrjola <at solidboot.com>
-Juha Yrjola <juha.yrjola@nokia.com>
-Juha Yrjola <juha.yrjola@solidboot.com>
-Kay Sievers <kay.sievers@vrfy.org>
-Kenneth W Chen <kenneth.w.chen@intel.com>
-Koushik <raghavendra.koushik@neterion.com>
-Leonid I Ananiev <leonid.i.ananiev@intel.com>
-Linas Vepstas <linas@austin.ibm.com>
-Matthieu CASTET <castet.matthieu@free.fr>
-Michael Buesch <mb@bu3sch.de>
-Michael Buesch <mbuesch@freenet.de>
-Michel Dänzer <michel@tungstengraphics.com>
-Mitesh shah <mshah@teja.com>
-Morten Welinder <terra@gnome.org>
-Morten Welinder <welinder@anemone.rentec.com>
-Morten Welinder <welinder@darter.rentec.com>
-Morten Welinder <welinder@troll.com>
-Nguyen Anh Quynh <aquynh@gmail.com>
-Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
-Patrick Mochel <mochel@digitalimplant.org>
-Peter A Jonsson <pj@ludd.ltu.se>
-Praveen BP <praveenbp@ti.com>
-Rajesh Shah <rajesh.shah@intel.com>
-Ralf Baechle <ralf@linux-mips.org>
-Ralf Wildenhues <Ralf.Wildenhues@gmx.de>
-Rémi Denis-Courmont <rdenis@simphalempin.com>
-Rudolf Marek <R.Marek@sh.cvut.cz>
-Rui Saraiva <rmps@joel.ist.utl.pt>
-Sachin P Sant <ssant@in.ibm.com>
-Sam Ravnborg <sam@mars.ravnborg.org>
-S.Çağlar Onur <caglar@pardus.org.tr>
-Simon Kelley <simon@thekelleys.org.uk>
-Stéphane Witzmann <stephane.witzmann@ubpmes.univ-bpclermont.fr>
-Stephen Hemminger <shemminger@osdl.org>
-Tejun Heo <htejun@gmail.com>
-Thomas Graf <tgraf@suug.ch>
-Tony Luck <tony.luck@intel.com>
-Tsuneo Yoshioka <Tsuneo.Yoshioka@f-secure.com>
-Valdis Kletnieks <Valdis.Kletnieks@vt.edu>

