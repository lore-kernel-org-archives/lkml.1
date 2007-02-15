Return-Path: <linux-kernel-owner+w=401wt.eu-S966002AbXBOQQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966002AbXBOQQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966038AbXBOQQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:16:58 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:41984 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966002AbXBOQQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:16:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RhaQX4k7wfoawpunP2p27+bBgkYP3cP1/bgCdquCZJKXkaqksKVuwuMiuFqbYHbmCzd0Y+pVmraHEHnIPmBy75lWRaiUwZDMcJ855gkp2MkZnaY2dHI9MF87rDN5RoJFBveQIQwvXsIx5cg+Rnv7RGUfY/n41qNjYrQcXYMzhU4=
Message-ID: <8d158e1f0702150816gdbf3451xa68623eb5b4ea910@mail.gmail.com>
Date: Thu, 15 Feb 2007 17:16:52 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: libsata tests started
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <45D3E854.6020701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8d158e1f0702100822i28d0bcds91cf27fc34534d2c@mail.gmail.com>
	 <20070210114155.6f7433c8.randy.dunlap@oracle.com>
	 <8d158e1f0702101214j603e1880i7eae2d94b446bc0b@mail.gmail.com>
	 <20070210203504.129b35ac@localhost.localdomain>
	 <8d158e1f0702101232q244a890fg450aa039689fcb3a@mail.gmail.com>
	 <8d158e1f0702101404s457fd1fx72f838021d7831b7@mail.gmail.com>
	 <6bffcb0e0702101423xd854b59x22d1d08f89ffa42c@mail.gmail.com>
	 <8d158e1f0702130031n75926241q83733cceb4080aa9@mail.gmail.com>
	 <45D3E854.6020701@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/07, Tejun Heo <htejun@gmail.com> wrote:

> I appreciate the testing.  One interesting but tedious test would be
> suspend tests (both to disk and ram).  Most libata drivers using new EH
> should be ready for them.  Oh, well, there's should and there's reality.

I will do these tests when I am at home, no problem :)
