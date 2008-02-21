Return-Path: <linux-kernel-owner+w=401wt.eu-S934004AbYBUQF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934004AbYBUQF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761521AbYBUQFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:05:44 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:36676 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758379AbYBUQFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:05:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=KT2wJ3APGZ1bKgVkiPRZAoou8e/g+8/DSrL5DvtrglPw09+ywE2xFcVqCH6cRglPsmcLxtk2IqiVcqVNuaBJloU7xUCN7PHvH/w8hZQ6zkUlOa1KVQcHbs3apNwLCPgeOHMyGDdtISNxuP0yUF7l0o+wzz6jcdVp3ZtCdOWW/48=
Message-ID: <47BDA141.70806@gmail.com>
Date: Thu, 21 Feb 2008 11:05:21 -0500
From: Andrew Buehler <abuehler.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Pinter <oliver.pntr@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: USB regression (and other failures) in 2.6.2[45]* - mostly resolved
References: <Pine.LNX.4.44L0.0802201428390.7056-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802201428390.7056-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/20/2008 2:29 PM, Alan Stern wrote:

> On Wed, 20 Feb 2008, Andrew Buehler wrote:
> 
>> In other words: I don't think that's likely to be practical in the
>> present instance. If you have reason to believe otherwise (past
>> positive experience with Novell, for instance), I'd be glad to hear
>> it.
> 
> Greg KH may be able to help in that respect.

I know he's in the CC:, but I'm not sure he's reading this thread, and
I'm hesitant to bother people about things out of the blue unless I have
reason to expect that it's something they're going to care about. (Just
because it's a big deal for me doesn't mean it makes one whit of
difference to anyone else, and from what little I've seen on
linux-kernel he seems to be somewhat important and fairly busy...)

>> Is there any place (aside from maybe the kernel changelog, which
>> contains a whole lot - if not several lots - of unrelated
>> information) where I could find a list of config-symbol name
>> additions, changes, deletions and meaning changes by version or by
>> date? That would at least let me build a mapping between the
>> symbols in the older config and the ones in the new one, which is
>> about where I would have to start.
> 
> Not as far as I know.

Then I suppose I'm reduced to browsing the Kconfig files, reading old
changelogs, and trying a lot of different configs... thanks anyway.

-- 
    Andrew Buehler
