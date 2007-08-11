Return-Path: <linux-kernel-owner+w=401wt.eu-S1757338AbXHKIfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbXHKIfx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 04:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbXHKIfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 04:35:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:51517 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672AbXHKIfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 04:35:41 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Noatime vs relatime
To: Rene Herman <rene.herman@gmail.com>,
       Matti Aarnio <matti.aarnio@zmailer.org>, Vlad <vladc6@yahoo.com>,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Sat, 11 Aug 2007 10:33:17 +0200
References: <8QDOX-78C-15@gated-at.bofh.it> <8QErs-8dz-1@gated-at.bofh.it> <8QLCI-2zy-15@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1IJmPN-0000bQ-4C@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19QCWesJ+2f3//HMuWueBKsBgKmrzA9UKQPkwW
 7OrlFNDquHckkJ/ZXBmlzoDgkxaobajp3EbZSipX6w29OkgSCg
 hd/MfiBJ0COzl0Yt+65vA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman <rene.herman@gmail.com> wrote:

> I must say I've been wondering about relatime a bit as well. Are there
> actually users who do really want atime, but not badly enough to want real
> atime?

Anyone using /var/spool/mail.
-- 
Programming is an art form that fights back. 

Friﬂ, Spammer: unhZ6GcWf@CQ.7eggert.dyndns.org
 BpD@ejtlDUeA.7eggert.dyndns.org T@e.7eggert.dyndns.org
