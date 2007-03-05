Return-Path: <linux-kernel-owner+w=401wt.eu-S933275AbXCEU6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275AbXCEU6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 15:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933258AbXCEU6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:58:14 -0500
Received: from mbox.ssc.unict.it ([151.97.230.9]:46839 "EHLO ssc.unict.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933167AbXCEU6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:58:08 -0500
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Subject: [PATCH 01/11] uml: code convention cleanup of a file
Date: Mon, 05 Mar 2007 21:48:59 +0100
To: Andrew Morton <akpm@osdl.org>
Cc: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Message-Id: <20070305204859.9072.71836.stgit@americanbeauty.home.lan>
In-Reply-To: <20070305204229.9072.17032.stgit@americanbeauty.home.lan>
References: <20070305204229.9072.17032.stgit@americanbeauty.home.lan>
Content-Type: text/plain; charset=utf-8; format=fixed
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by alpha.home.local id l25L4WZJ008328

From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

Fix coding conventions violations is arch/um/os-Linux/helper.c.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
---

 arch/um/os-Linux/helper.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/os-Linux/helper.c b/arch/um/os-Linux/helper.c
index c7ad630..7954357 100644
--- a/arch/um/os-Linux/helper.c
+++ b/arch/um/os-Linux/helper.c
@@ -38,7 +38,7 @@ static int helper_child(void *arg)
 	char **argv = data->argv;
 	int errval;
 
-	if (helper_pause){
+	if (helper_pause) {
 		signal(SIGHUP, helper_hup);
 		pause();
 	}


