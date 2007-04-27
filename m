Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbXD0HGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbXD0HGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 03:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbXD0HGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 03:06:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:52398 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbXD0HGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 03:06:18 -0400
Message-ID: <4631A0F0.4060308@gmx.net>
Date: Fri, 27 Apr 2007 09:06:24 +0200
From: Klaus Strebel <klaus.strebel@gmx.net>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Eric Sandeen <sandeen@sandeen.net>, Jesper Juhl <jesper.juhl@gmail.com>,
       David Chinner <dgc@sgi.com>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
       viro@zeniv.linux.org.uk
Subject: Re: 2.6.20.3 - possible recursive locking detected - in XFS
References: <200704251116.57737.jesper.juhl@gmail.com>	 <20070425233345.GN48531920@melbourne.sgi.com> <9a8748490704260317u211c244au3c5478ac02c12c43@mail.gmail.com> <4630DDC2.2040705@sandeen.net>
In-Reply-To: <4630DDC2.2040705@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1/woEZC0TSQY/S9fbTr2YWHkJBxAE71dpr02Oa
 ENMHbzJ1Et7D3sETq5yU1+HEXk9s+RXHDgmM4wc6otvPvhII+c
 bs0gypp+44870dNdBsRcw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen schrieb:
> Jesper Juhl wrote:
>> On 26/04/07, David Chinner <dgc@sgi.com> wrote:
> 
>>> Known false positive - XFS doesn't have the annotations needed for
>>> this yet; we've got a patch that will probably make it's way into 6.5.22 that
>>> should fix most of these issues.
> 
> wow... 6.5.22.... do we really have to wait that long? :)

Why wait? If i remember right ( it's about 3 years ago that it had to do
with it ), its a quite old patch-version of mother ... IRIX :-)

It's fun to see that your can't hide your roots Dave :-) ...

so now that .21 ( of the Linux 2.6 series ) i wonder, will there be
anybody remembering IRIX 6.5.22 when the Linux kernel reaches to that
version number? Hey Google, suck this message in and help us remember
this question !

Cheers to all friends of Linux und IRIX
Klaus

P.S.: Guess i will have to boot my old Indy at home, arrrggghhh,
clock-chip battery will be empty again ... 'll have to reset the MAC ...
must recover the lost root password ... oh Lord ( no, not you Steve ... )

-- 
Mit freundlichen Grüssen / best regards

Klaus Strebel, Dipl.-Inform. (FH), mailto:klaus.strebel@gmx.net

/"\
\ /     ASCII RIBBON CAMPAIGN
 X        AGAINST HTML MAIL
/ \
