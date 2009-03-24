Return-Path: <linux-kernel-owner+w=401wt.eu-S1761982AbZCXObR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761982AbZCXObR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760844AbZCXOa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:30:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:52551 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759988AbZCXOa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:30:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        b=FG4nwPhWV0rtfrwjuuZBVCD6eEpjjifeC2hAHWd3qMJoGyTmHjJwS1HSv2UTLohRW9
         FtEAyf/xKXtSdwO2GZgRyGpgg+KGqeW6a2twqiHcYlIBHFCSD3/1DTk5QZZ86xeA+Ivb
         HGNcE2RAC8VDIEIW8R75gzUsJtAIn54BzGVbI=
Date: Tue, 24 Mar 2009 07:30:50 -0700 (PDT)
From: justinmattock@gmail.com
To: db <db.pub.mail@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: misspelling on line 1190 of net/ipv4/udp.c .
In-Reply-To: <25ae2d690903240122k3aad9e0dr1080396711daf3c6@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.0903240729250.1958@havk>
References: <25ae2d690903240122k3aad9e0dr1080396711daf3c6@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009, db wrote:

> Hi, i think there is a misspelling of the  word checksumming (if it
> is an actual  word ^^) on line 1190 of net/ipv4/udp.c .
>
> The line reads, " * Otherwise, csum completion requires chacksumming
> packet body,"
>
> Perhaps the line can be changed to "* Otherwise, csum completion
> requires a checksum of the packet body".
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


Well.
What are you waiting for, submit a patch. :^)

regards,

-- Justin P. Mattock
