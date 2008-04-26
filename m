Return-Path: <linux-kernel-owner+w=401wt.eu-S1760998AbYDZXrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760998AbYDZXrf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 19:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbYDZXr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 19:47:26 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:35169 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbYDZXrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 19:47:25 -0400
Message-ID: <4813BF14.8090109@keyaccess.nl>
Date: Sun, 27 Apr 2008 01:47:32 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 00/54] PNP cleanup, v4
References: <20080425183807.366134771@ldl.fc.hp.com> <4813BBE9.2010803@keyaccess.nl>
In-Reply-To: <4813BBE9.2010803@keyaccess.nl>
Content-Type: multipart/mixed;
 boundary="------------020901080502050401040701"
X-Spam-Score: -0.5 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020901080502050401040701
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 27-04-08 01:34, Rene Herman wrote:

> Good idea...

By the way, would you terribly mind submitting this alongside? It's been 
ages since we heard from Adam.

Rene

--------------020901080502050401040701
Content-Type: text/plain;
 name="pnp-maintainer.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pnp-maintainer.diff"

diff --git a/MAINTAINERS b/MAINTAINERS
index a942f38..7b10551 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3171,8 +3171,8 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 
 PNP SUPPORT
-P:	Adam Belay
-M:	ambx1@neo.rr.com
+P:	Bjorn Helgaas
+M:	bjorn.helgaas@hp.com
 S:	Maintained
 
 PNXxxxx I2C DRIVER

--------------020901080502050401040701--
