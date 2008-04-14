Return-Path: <linux-kernel-owner+w=401wt.eu-S1758461AbYDNCdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461AbYDNCdU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 22:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYDNCdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 22:33:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:40301 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbYDNCdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 22:33:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=WBbQdQlCw11yvSDngPlOuRQun+e2QSOzGqDhtitWvXptLE0DxD1Z87ShUKitOwPxTtvHTHgOiFry4FLtd1kmcURi1yiKhTCZCSMcy7hRA+wQ803a8Z408oVSPqhbnJy4EGgv+b6WAqbS9MPeNF6uzy0iamNolhv3mwIu6EwQ9tY=
Message-ID: <4802C265.8060802@gmail.com>
Date: Mon, 14 Apr 2008 06:33:09 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>, akpm@linux-foundation.org,
       corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Fix typos in Documentation/filesystems/seq_file.txt
References: <1208111201-15698-1-git-send-email-dmitri.vorobiev@gmail.com>	<20080413151020.bfa62f58.randy.dunlap@oracle.com>	<48028841.900@gmail.com>	<20080413224547.GS9785@ZenIV.linux.org.uk> <20080413190916.57cede66.randy.dunlap@oracle.com>
In-Reply-To: <20080413190916.57cede66.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap пишет:
> On Sun, 13 Apr 2008 23:45:47 +0100 Al Viro wrote:
> 
>> On Mon, Apr 14, 2008 at 02:25:05AM +0400, Dmitri Vorobiev wrote:
>>
>>> Actually, I was doubting whether the "2 spaces" thing was
>>> intentional or not. The overwhelming majority of the sentences in
>>> this document use only one space after a period, however, and this
>>> made me decide that the "2 spaces" thing had not been deliberate
>>> but just a typo.
>>>
>>> Are there any rules about using spaces after a period at the end
>>> of a sentence?
>> See Knuth (TeXbook) for the story on that...
> 
> I googled that but I don't see the history there.
> 
> AFAIK, 2 spaces at the end of sentences is a typewriter-ism, for easier
> visual separation of sentences.
> Probably (just guessing here) has to do with monospace fonts vs.
> (not having) proportional ones there (usually).

The following Wikipedia article is the most complete and exhaustive source
I could find while researching the double spacing rules:

http://en.wikipedia.org/wiki/French_spacing

To put it briefly, there are three main conventions about inter-sentence
spacing:

o English spacing a.k.a. American typewriter spacing: two spaces after full stop;

o French spacing, i.e. one space;

o traditional typography, which uses proportional fonts and is therefore not
very much interesting here.

Offhand, it seems that the double spacing convention is being currently used
in a more or less consistent manner throughout Linux docs. It also seems to
me that this can be made a requirement and documented somewhere.

Thanks,
Dmitri

> 
> ---
> ~Randy
> [Yes, I learned to type on a manual typewriter.]
> 

