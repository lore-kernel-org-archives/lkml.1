Return-Path: <linux-kernel-owner+w=401wt.eu-S1758580AbYD0IdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580AbYD0IdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 04:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbYD0IdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 04:33:14 -0400
Received: from webbox4.loswebos.de ([213.187.93.205]:59007 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbYD0IdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 04:33:14 -0400
X-Greylist: delayed 1526 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Apr 2008 04:33:13 EDT
To: Linux-LKLM <linux-kernel@vger.kernel.org>
Subject: =?ISO-8859-1?Q?[GIT / ALSA] Sound mu?=  =?ISO-8859-1?Q?ted until PCM value c?=  =?ISO-8859-1?Q?hanged?=
X-PHP-Script: www.adminconfig.de/poplogin/email_neu.php for 80.130.197.23
From: marc@osknowledge.org
X-Priority: 3
Importance: Normal
X-MSMail-Priority: Normal
X-MimeOLE: Produced by Confixx WebMail
X-Mailer: Confixx WebMail (like SquirrelMail)
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <20080427080745.BAE2B1AF25A7@webbox4.loswebos.de>
Date: Sun, 27 Apr 2008 10:07:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

with my latest GIT from yesterday (b1721d0), ALSA sound is muted until I
change the PCM value. The values are correctly restored on boot but one
cannot
hear any sound.

Does anyone have similar problems?

Regards,
Marc



