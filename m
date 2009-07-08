Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbZGHNJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbZGHNJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 09:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbZGHNJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 09:09:47 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:60690 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbZGHNJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 09:09:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AEnDCaNV3nV9WIlmljVTTwLVjAEVqPO2A76Jh1Q4xO/WMWisqdrJ64WbXY56/Y5DkZ
         l+78yL7aOpq4DfnxXzgAjoM3BI1h1tzNvA8ygoKkWeuZo3Pt3W3T5ORpIebmyHrG/Ng1
         UgysjMkDjiKSJNrZCJmnyh1JHI60CLZI4+M3A=
MIME-Version: 1.0
In-Reply-To: <20090702130728.22af524c.akpm@linux-foundation.org>
References: <4A4CB4B4.5010307@turknet.net.tr>
	 <20090702130728.22af524c.akpm@linux-foundation.org>
Date: Wed, 8 Jul 2009 15:09:44 +0200
Message-ID: <8db1092f0907080609w60e37ac0id49a44bd4796b425@mail.gmail.com>
Subject: Re: [BUG] Linux-2.6.31-rc1-git9 Cannot Recognize Empty DVD Media
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tarkan Erimer <tarkan.erimer@turknet.net.tr>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar issue on 2 machines. 2.6.31-rc1-git3 works ok. 2.6.31-rc2
cannot recognize *any* DVD media with K3b. No messages in dmesg or
syslog.

Unfortunately I can't try bisection, because I don't have more time
(work). I try do it at the end of week.

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
