Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbYLLHVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbYLLHVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 02:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYLLHVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 02:21:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:9414 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbYLLHVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 02:21:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vzbt58CFRWjRpMIVYkdrd02UAf7Pe4GXWr+Lr1xvGV/+edDhNsrg5RdZsGnPwGE26p
         Tm5Ak0zGT8CFLutI/OOW7/TgkKYP0QAJI2Ww59ZD78yOSq8Oj26NEoaoiMpoF90+Ata7
         fO+Brtogoxy20rXeuKKIAI9JKldoxTD3QMTZs=
Message-ID: <e2e108260812112321w2f5b1827xe2593888e44808ae@mail.gmail.com>
Date: Fri, 12 Dec 2008 08:21:08 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: linux-iscsi-target-dev@googlegroups.com
Subject: Re: [Announce]: Target_Core_Mod/ConfigFS and LIO-Target v3.0 work
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Christoph Hellwig" <hch@lst.de>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Mike Christie" <michaelc@cs.wisc.edu>,
       "Hannes Reinecke" <hare@suse.de>, "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <1229025513.4153.542.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228965271.4153.510.camel@haakon2.linux-iscsi.org>
	 <e2e108260812111124j79793adcie106ac2da4f801f3@mail.gmail.com>
	 <1229025513.4153.542.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 8:58 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>
> On Thu, 2008-12-11 at 20:24 +0100, Bart Van Assche wrote:
>> On Thu, Dec 11, 2008 at 4:14 AM, Nicholas A. Bellinger
>> <nab@linux-iscsi.org> wrote:
>> > Things are moving quickly for Target_Core_Mod/ConfigFS and LIO-Target
>> > v3.0 development, and I invite folks to have a look at the code.  To
>> > dive into the rest of the v3.0 code via git-web, check out:
>> >
>> > http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=tree;f=drivers/lio-core
>>
>> I didn't have a look at the LIO code, but I ran it through checkpatch.
>> The result summary is as follows:
>>
> Thanks for the note, but checkpatch output on the entire tree (not just
> the patchs I posted) does not really help the discussion.  Obviously
> this is on my list before submission for Target_Core_Mod/ConfigFS for
> v2.6.29.  However, what would be nice if you actually sent a kernel
> patch for these issues.

I ran checkpatch on the files in drivers/lio-core ONLY. I did this by
converting all the files in drivers/lio-core through a script into a
patch, and by running checkpatch on the generated patch.

And as you already know I'm not going to work on LIO.

Bart.
