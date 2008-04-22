Return-Path: <linux-kernel-owner+w=401wt.eu-S1765008AbYDVPFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765008AbYDVPFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbYDVPFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:05:01 -0400
Received: from h155.mvista.com ([63.81.120.155]:30381 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752012AbYDVPFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:05:00 -0400
Message-ID: <480DFE76.8000809@ru.mvista.com>
Date: Tue, 22 Apr 2008 19:04:22 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.6 patch] select ATA_SFF
References: <20080421213147.GH2633@cs181133002.pp.htv.fi> <480DE3C4.5@ru.mvista.com> <480DE6F5.8060403@gmail.com> <480DE9E8.2070809@ru.mvista.com> <480DEB1F.5060500@gmail.com> <480DF7B7.9030000@rtr.ca> <480DF876.7070800@gmail.com> <480DF9BD.1080104@rtr.ca>
In-Reply-To: <480DF9BD.1080104@rtr.ca>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:

>>> SFF stands for "Small Form Factor", as in the "SFF Committee Information
>>> Specification for Bus Master Programming Interface for IDE ATA 
>>> Controllers Rev 1.0"
>>> from May 16, 1994.

>>> That document is basically a committee rubber-stamp of the earlier Intel
>>> "PCI IDE Controller Specification Revision 1.0" dated 3/4/94.

>> Ah.. that means we have the whole naming thing wrong.  Yewwww....

> ..

> I suppose.   If we were needlessly pedantic, then perhaps
> the libata-bmdma.c should be renamed to libata-sff.c,
> and the libata-sff.c should be renamed libata-tf.c

    Which branch has libata-bmdma.c?

> But there's probably been a document or two since then,
> where the SFF folks have documented the TF interfaces, too.

    Don't know, at least I haven't encountered such spec. Unless you mean 
SFF-8020i (ATAPI CD-ROM spec).

> So.. whatever.  :)

MBR, Sergei
