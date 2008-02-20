Return-Path: <linux-kernel-owner+w=401wt.eu-S1754963AbYBTHrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbYBTHrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 02:47:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYBTHqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 02:46:52 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:49356 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbYBTHqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 02:46:51 -0500
Message-ID: <47BBDAE5.4090000@garzik.org>
Date: Wed, 20 Feb 2008 02:46:45 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: Re: linux-next: Tree for Feb 20
References: <20080220163457.79b9189f.sfr@canb.auug.org.au> <20080220055055.GC31832@kroah.com>
In-Reply-To: <20080220055055.GC31832@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Feb 20, 2008 at 04:34:57PM +1100, Stephen Rothwell wrote:
>> Hi all,
>>
>> I have created today's linux-next tree at
>> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git.
>>
>> You can see which trees have been included by looking in the Next/Trees
>> file in the source.  There are also quilt-import.log and merge.log files
>> in the Next directory.  Between each merge, the tree was built with
>> allmodconfig for both powerpc and x86_64.
> 
> What's the best way to constantly follow this tree?  I had cloned it a
> while ago, but now if I 'git pull' it wants to merge things, which isn't
> right.
> 
> I'm guessing that this is constantly being rebased?  Against what,
> Linus's tree?  So we should be able to clone Linus's tree, and then pull
> in -next?
> 
> Or am I totally missing something here?

You can use 'git fetch -f' to override your local tree with the remote 
contents.

I'm pretty sure there's a better way to do it, but I don't know it...

	Jeff



