Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbYDMWty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbYDMWty (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 18:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbYDMWtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 18:49:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:22171 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbYDMWtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 18:49:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=P7mmFv6y/M8NQc5LhX85EdnkkDwBrFxqwYI4oEg9F6NOkX2JHy7AU8164wVr73RdSaz/hjw8uwBKGBE6dGLrPr33QVThdYt/+EQ9d43WJg9iSx7YKJ9PPgtBXda82K7W/YWjs89N0n3+gFENPbN1w+A9sIAxymxiLwMONJXEW18=
Message-ID: <48028E0B.4010603@gmail.com>
Date: Mon, 14 Apr 2008 02:49:47 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org,
       corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Fix typos in Documentation/filesystems/seq_file.txt
References: <1208111201-15698-1-git-send-email-dmitri.vorobiev@gmail.com> <20080413151020.bfa62f58.randy.dunlap@oracle.com> <48028841.900@gmail.com> <20080413224547.GS9785@ZenIV.linux.org.uk>
In-Reply-To: <20080413224547.GS9785@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Mon, Apr 14, 2008 at 02:25:05AM +0400, Dmitri Vorobiev wrote:
> 
>> Actually, I was doubting whether the "2 spaces" thing was
>> intentional or not. The overwhelming majority of the sentences in
>> this document use only one space after a period, however, and this
>> made me decide that the "2 spaces" thing had not been deliberate
>> but just a typo.
>>
>> Are there any rules about using spaces after a period at the end
>> of a sentence?
> 
> See Knuth (TeXbook) for the story on that...
> 

Thanks, Al.

Dmitri
