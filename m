Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbYI3INZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbYI3INZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 04:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbYI3INN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 04:13:13 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:36540 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751958AbYI3INM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 04:13:12 -0400
Date: Tue, 30 Sep 2008 10:12:57 +0200
From: Konstantin Kletschke <lists@ku-gbr.de>
To: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
Message-ID: <20080930081257.GB18961@anita.doom>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <48B80B40.5060002@shaw.ca> <48B80D33.5050806@gmail.com> <20080829212146.GA4321@anita> <48B90F7F.8040308@kernel.org> <48D89C85.2080104@panasas.com> <20080924084846.GA2094@anita> <48DA0A2C.8010008@kernel.org> <20080924105943.GB2094@anita> <20080925081848.GB2305@anita> <48DEA40D.40709@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DEA40D.40709@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2008-09-28 06:22 +0900 schrieb Tejun Heo:

> Sorry about lack of response.  I was on vacation after a series of

Thats no Problem at all :-) I hope the vacation was fine.

> conferences.  There's a bug entry for this problem and I just posted a
> patch.
> 
>   http://bugzilla.kernel.org/show_bug.cgi?id=11615
> 
> Can you please try the patch attached there and post the result
> there?

Well, this Patch simply installs the old weird behaviour with the
result in sometimes no cold boot possible yielding into

ataX: link too slow to response ...
ataX: COMRESET failed (errno=-16)

After that powercycle required. I wrote it down from memory. If there
is a detailed log required I can create them tomorrow when I have my
Hands back onto the machine.

Kind Regards, Konsti

-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
