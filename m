Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbYEPTv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbYEPTv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 15:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYEPTvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 15:51:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbYEPTvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 15:51:51 -0400
Message-ID: <482DE5F1.2080303@redhat.com>
Date: Fri, 16 May 2008 15:52:17 -0400
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org,
       "Schoeller, Patrick (Linux - Houston, TX)" <Patrick.Schoeller@hp.com>
Subject: Re: [PATCH] PCI: Correct last two HP entries in the bfsort whitelist
References: <482C838E.3030203@redhat.com> <20080515220215.76eea915@core> <482CB7D7.30008@redhat.com> <200805161029.55649.jbarnes@virtuousgeek.org>
In-Reply-To: <200805161029.55649.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> Ok, I'll put it in linux-next for now then.  It would be good to hear some 
> feedback from users about it though...
> 
> Thanks,
> Jesse

Jesse,

I would like to add that HP has tested the patch, and our risk
assessment shows more benefit for HP ProLiant customers than the
possible adverse affects.

Since this patch only affects the two HP ProLiant platforms listed, and
since HP is willing to take ownership for any problems related to the
patch, we would like to see it ACK'd and added to the current 2.6.26
kernel.

Regards,
Tony
