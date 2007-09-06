Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbXIFJYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbXIFJYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 05:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbXIFJYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 05:24:06 -0400
Received: from mpc-26.sohonet.co.uk ([193.203.82.251]:47186 "EHLO
	moving-picture.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753695AbXIFJYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 05:24:04 -0400
Message-ID: <46DFC711.6090100@moving-picture.com>
Date: Thu, 06 Sep 2007 10:23:29 +0100
From: James Pearson <james-p@moving-picture.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040524
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Anton Arapov <aarapov@redhat.com>,
       Guy Streeter <guy.streeter@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 4096 byte limit to /proc/PID/environ ?
References: <4474B7DB.8000304@moving-picture.com>	<200605242029.k4OKTn9C031700@terminus.zytor.com>	<447EF58C.6000605@moving-picture.com>	<52dd17640708150954q798d137cn1b07739785917c5b@mail.gmail.com>	<46C33700.1060605@zytor.com>	<46D6CBED.4040301@moving-picture.com>	<h87in5sgal.fsf@pepelac.englab.brq.redhat.com>	<46DE6196.3050605@zytor.com>	<46DEE0C9.1000402@moving-picture.com> <20070905101804.eafd0da4.randy.dunlap@oracle.com>
In-Reply-To: <20070905101804.eafd0da4.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Disclaimer: This email and any attachments are confidential, may be legally
X-Disclaimer: privileged and intended solely for the use of addressee. If you
X-Disclaimer: are not the intended recipient of this message, any disclosure,
X-Disclaimer: copying, distribution or any action taken in reliance on it is
X-Disclaimer: strictly prohibited and may be unlawful. If you have received
X-Disclaimer: this message in error, please notify the sender and delete all
X-Disclaimer: copies from your system.
X-Disclaimer: 
X-Disclaimer: Email may be susceptible to data corruption, interception and
X-Disclaimer: unauthorised amendment, and we do not accept liability for any
X-Disclaimer: such corruption, interception or amendment or the consequences
X-Disclaimer: thereof.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
>>
>>OK, here is the patch (without the long line) against 2.6.23-rc5 - what 
>>else needs to be done to get it committed?
> 
> 
> Hi,
> 
> a.  It needs a changelog that describes the problem and the patch.
> b.  It needs to apply cleanly to a current kernel.
>     (It does not apply cleanly now due to some odd line breaks [see #1
>     below.)
> c.  It needs to use tabs instead of spaces.  That will probably help
>     on item b as well.
> 
> linux-2.6.23-rc5> dryrun < ~/fs-proc-read-sizes.patch 
> 4 out of 4 hunks FAILED -- saving rejects to file fs/proc/base.c.rej

I think a 'cut-n-paste' to my mail app mangled the patch - I'll 
re-submit it 'cleanly' ...

Thanks

James Pearson
