Return-Path: <linux-kernel-owner+w=401wt.eu-S965171AbXAYMd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965171AbXAYMd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 07:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965273AbXAYMd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 07:33:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:50119 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965171AbXAYMd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 07:33:56 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
To: Scott Preece <sepreece@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Alessandro Di Marco <dmr@gmx.it>, linux-kernel@vger.kernel.org,
       vojtech@suse.cz
Reply-To: 7eggert@gmx.de
Date: Thu, 25 Jan 2007 13:28:36 +0100
References: <7ELhf-4rC-9@gated-at.bofh.it> <7FKM6-7Gy-1@gated-at.bofh.it> <7G6ME-1g2-11@gated-at.bofh.it> <7GqrZ-6YY-1@gated-at.bofh.it> <7GuFj-5pj-5@gated-at.bofh.it> <7GwQL-h3-7@gated-at.bofh.it> <7GzF3-4L6-47@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1HA3iW-0000kF-VU@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9b3b2cc444a07783f194c895a09f1de9
X-Provags-ID2: V01U2FsdGVkX19XdAwYIfW4ORDR/TVEpfAfEYBtur4hX5heop3+oY5oL8bd2efyPYk5OU1PbpsCoA7fk+Kv3sHtE3LtdsrRkeWnlLyrLGABXT90g1BWwxnYtg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Preece <sepreece@gmail.com> wrote:

> My own hot button is making sure that the definition of what
> constitutes user activity is managed in exactly one place, whether in
> the kernel or not. My naive model would be to put the response at user
> level, but to provide a single point of definition in the kernel (say,
> /dev/useractivity or the equivalent) that the user-level daemon could
> listen to.

Imagine one computer serving two users. Two monitors, two keyboards ...
-- 
Funny quotes:
38. Last night I played a blank tape at full blast. The mime next door went
    nuts.
Friﬂ, Spammer: hEOzVVU@voJ.7eggert.dyndns.org
