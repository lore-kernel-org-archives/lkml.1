Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbZKHN6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbZKHN6H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 08:58:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbZKHN6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 08:58:06 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:38763 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbZKHN6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 08:58:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=IMO9gCBCsioBAT4YkIreFW5f0F6mH+rmEvvgKLBdpjU4zv0LhK5ne2ZxVdYlyEIahp
         EF1ZtBL4SYyOcanY9DiDQGu4Ri9EskwqkonFCw6GN+tS9t6meTv4Naq9J89sNSf/uP3f
         hlJD1gCr+yoaNWoaCRRYIo0AwQrUoHxUhhCfk=
MIME-Version: 1.0
In-Reply-To: <a4c8a6d00911080538y3735e6bbq9c1bdc4ba90e2ead@mail.gmail.com>
References: <1257195888-6122-1-git-send-email-tfransosi@gmail.com> 
	<0F1B54C89D5F954D8535DB252AF412FA05042B1D@chinexm1.ad.analog.com> 
	<a4c8a6d00911080538y3735e6bbq9c1bdc4ba90e2ead@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 8 Nov 2009 08:57:51 -0500
Message-ID: <8bd0f97a0911080557g50acadb6yb1e9da3ab06a196f@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH] blackfin/trivial: remove 
	duplicatedMAX macro from stamp.
To: Thiago Farina <tfransosi@gmail.com>
Cc: "Zhang, Sonic" <Sonic.Zhang@analog.com>, trivial@kernel.org,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       linux-kernel@vger.kernel.org, "Song, Barry" <Barry.Song@analog.com>,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 8, 2009 at 08:38, Thiago Farina wrote:
> On Fri, Nov 6, 2009 at 1:17 AM, Zhang, Sonic wrote:
>> Acked-by: Sonic Zhang<sonic.zhang@analog.com>
>
> Could you apply this to blackfin tree?

he has merged it into the svn tree we have.  i havent picked it up in
the Blackfin git tree yet as ive been busy with some other projects.
i should be able to get it in before 2.6.32 final though.
-mike
