Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbXIESCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbXIESCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 14:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbXIESC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 14:02:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:62853 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbXIESCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 14:02:25 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: modinfo <modulename> question
To: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Wed, 05 Sep 2007 20:02:16 +0200
References: <9065c-7jN-17@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1ISzCi-0000cv-Vj@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18RcgU0GVn4ZPVBTIyjE4fb/VM7jW26oj4urQt
 lUSDZf10MiVNm70dd7PEZT8Wlrr3TFpGdD+JwFrZSwPhaVTTjZ
 KMhh69ZAADJNnS7Zb1Pew==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> Is there anyway to get/see what parameters were passed to a kernel module?
> Running modinfo -p <module> will show the defaults, but for example, st,
> the scsi tape driver, is there a way to see what it is currently using?

/sys/modules/$NAME/parameters (if it's using the new API)
-- 
It is still called paranoia when they really are out to get you.

Friﬂ, Spammer: uMwxkC@h.7eggert.dyndns.org vTfI21zo@tjJ.7eggert.dyndns.org
 Ugj@SN6Crmm.7eggert.dyndns.org 8nFizbkCwk@-dTgS.7eggert.dyndns.org
