Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbYDMWZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbYDMWZX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 18:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbYDMWZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 18:25:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:35773 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbYDMWZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 18:25:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ED0PWCYg6g84rYynKDDmRO75m+aeYUDjHYSagUIdki2M++MgNtq40ZxCP79O8xb8Lq7xz3GZss7ATOARlM9VgeSGCp0iYzy6YXMkVCkBuMacfo8vhyI/QuTON0JchT1VdZ2LtLEdI3HsnGgt1g6iCoHl0QuJhBUeDDng2nWVjCM=
Message-ID: <48028841.900@gmail.com>
Date: Mon, 14 Apr 2008 02:25:05 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: akpm@linux-foundation.org, corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Fix typos in Documentation/filesystems/seq_file.txt
References: <1208111201-15698-1-git-send-email-dmitri.vorobiev@gmail.com> <20080413151020.bfa62f58.randy.dunlap@oracle.com>
In-Reply-To: <20080413151020.bfa62f58.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap пишет:
> On Sun, 13 Apr 2008 22:26:41 +0400 Dmitri Vorobiev wrote:
> 
>> A couple of typos crept into the newly added document
>> about the seq_file interface. This patch corrects those
>> typos and simultaneously deletes a few superfluous blanks.
> 
> The "2 spaces after a period at the end of a sentence" was done
> on purpose, I feel sure.  It's not a mistake.

OK, I'll redo the changes.

Actually, I was doubting whether the "2 spaces" thing was
intentional or not. The overwhelming majority of the sentences in
this document use only one space after a period, however, and this
made me decide that the "2 spaces" thing had not been deliberate
but just a typo.

Are there any rules about using spaces after a period at the end
of a sentence?

Thanks,
Dmitri
