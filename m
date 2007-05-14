Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbXENUqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbXENUqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756673AbXENUqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:46:14 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:49844 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507AbXENUqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:46:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=o8oqrWq+cb+8r6cDAw5D6S7Ku32/+7LMTvYvs2ZZsHX7NSWCyWaPO73Zl+lr9e+ToRlh+de34tj9kbSb50BWR6nFMzsaFO4AaTXS7TY/DYOB3y5lYiiFIhGDlT5CqQTzpu4HxzkrgtUIXQRzReOy8kD9Mrim0apG93TkXayW21U=
Message-ID: <e5ab0f710705141346o45ac8721jacbcb753f9d45406@mail.gmail.com>
Date: Mon, 14 May 2007 22:46:11 +0200
From: "Francesco Pretto" <ceztko@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
Cc: "Phillip Susi" <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46489D3B.8050805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no>
	 <fa.YHt2nIlQmoW5r2enmTSzsaySwH4@ifi.uio.no> <45DD0348.5040005@shaw.ca>
	 <e5ab0f710702231235ucb559eerb3639ec312aa312a@mail.gmail.com>
	 <463B858E.6060002@cfl.rr.com> <463B99EE.2090001@gmail.com>
	 <e5ab0f710705061119k35ba223j2ecca6e0f8495ed5@mail.gmail.com>
	 <46489D3B.8050805@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/14, Tejun Heo <htejun@gmail.com>
>
> Okay, the patch made upstream and webpage posted.
>
>  http://linux-ata.org/shutdown.html
>
> --
> tejun
>

Ubuntu [1] ang Gentoo [2] bugs opened. Sent a mail to Miquel van
Smoorenburg, dev  of sysvinit.

[1] https://bugs.launchpad.net/upstart/+bug/114683
[2] http://bugs.gentoo.org/show_bug.cgi?id=178559
