Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbXI3OSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbXI3OSt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 10:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755693AbXI3OSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 10:18:42 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:56114 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493AbXI3OSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 10:18:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=mPiVYLxgBdpfwZL8zRVxNfMfmACGRf8C1G72d+KdluWmh5TssJqxRDn3nyt+UmLXs0PDYpp479b/GTf34Qk7g8qdgEbE8Znb55YugzVAXQDvSmoobGNEz8XHRGshCVO1Bmdn/KzzjyP+Yj67EO44/SmbBm2TMzszmoDimxo6pJI=
Message-ID: <46FFAFE1.2010302@gmail.com>
Date: Sun, 30 Sep 2007 07:17:05 -0700
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Paolo Ornati <ornati@fastwebnet.it>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blacklist NCQ on Seagate Barracuda ST380817AS
References: <20070930160548.235be972@localhost>
In-Reply-To: <20070930160548.235be972@localhost>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Ornati wrote:
> Seagate Barracuda ST380817AS has troubles with NCQ. For example,
> unpacking a tarball on an XFS filesystem gives this:
> 
> ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
> ata1.00: cmd 61/40:00:29:a3:98/00:00:00:00:00/40 tag 0 cdb 0x0 data 32768 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)

Hmmm... Was there a thread about this one?  Also, please cc
linux-ide@vger.kernel.org.

Thanks.

-- 
tejun
