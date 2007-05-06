Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbXEFSYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbXEFSYW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 14:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754935AbXEFSYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 14:24:22 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:36539 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbXEFSYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 14:24:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=F66O09dM2owOaet7xMMPSdyflSY6xLqaxWie2jnsPcJQQICSulOZK37AmH4nRju4PlXQQJcJizRNPqo/5nIa2GReDygbIAuQqNU0C1tC5G1rGVFQkVtLgkswHDebrvBD2ZM/IbHT7xETfwxvae0lPTCadEFtEWRzDiQ3JrlYXBM=
Message-ID: <463E1D49.1060705@gmail.com>
Date: Sun, 06 May 2007 20:24:09 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Francesco Pretto <ceztko@gmail.com>
CC: Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no>	 <fa.YHt2nIlQmoW5r2enmTSzsaySwH4@ifi.uio.no> <45DD0348.5040005@shaw.ca>	 <e5ab0f710702231235ucb559eerb3639ec312aa312a@mail.gmail.com>	 <463B858E.6060002@cfl.rr.com> <463B99EE.2090001@gmail.com> <e5ab0f710705061119k35ba223j2ecca6e0f8495ed5@mail.gmail.com>
In-Reply-To: <e5ab0f710705061119k35ba223j2ecca6e0f8495ed5@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francesco Pretto wrote:
> Ok, i can't understand if the patch will be included in 2.6.22 (i
> didn't see it in the Andrew Morton merge plan). However, if you can
> confirm the inclusion, i can send bug reports for ubuntu and gentoo. I
> can even send an email to Miquel van Smoorenburg, who should be the
> mainstream sysvinit developer (and probably the last maintainer).

It hasn't generated too much response yet.  Anyways, yeap, merging it
for 2.6.22 is definitely the plan.  This thing can shorten lifespan of
harddisks.  :-(  I'll let you know if something changes.

Thanks.

-- 
tejun
