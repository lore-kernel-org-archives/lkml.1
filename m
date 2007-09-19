Return-Path: <linux-kernel-owner+w=401wt.eu-S1762834AbXISRfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762834AbXISRfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762399AbXISRdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:33:55 -0400
Received: from smtp.seznam.cz ([77.75.72.43]:48208 "HELO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1762360AbXISRdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:33:54 -0400
From: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
To: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Date: Wed, 19 Sep 2007 18:08:43 +0200
MIME-Version: 1.0
Subject: Re: [newbie:] Bonnie++2 hangs recent 2.6 kernels? Bash keeps looping in waitpid(), eating 100% CPU
Message-ID: <46F165AB.1975.48E0261F@localhost>
In-reply-to: <20070919083424.39e5ece1.randy.dunlap@oracle.com>
References: <46F0FF0D.10166.474F4A3F@localhost>
X-mailer: Pegasus Mail for Windows (4.21c)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Smtpd: 1.0.12@11920:11921
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 Sep 2007 at 17:34, Randy Dunlap wrote:
> On Wed, 19 Sep 2007 10:50:53 +0200 Frantisek Rysanek wrote:
> > I've been trying in vain to post a response to this thread...
> Check the taboo expressions here:
>   http://vger.kernel.org/majordomo-info.html#taboo
>
Thanks for your kind response :-)
I've checked the regexp's in the TABOO list visually and couldn't 
find any obvious violation, certainly not on part of my URL's.
Maybe there's some other word in my text.

Is there an easy way for me to scan a sample message (as a local flat 
file on my system) using that reference TABOO list, in an automated 
way? Such as feed the TABOO list to a scripted instance of 
sed/awk/perl? I'm only moderately familiar with perl-compatible 
regexp syntax, some of the lines seem odd to me...
I'm reluctant to download Majordomo and look for some references in 
its documentation / source code, to look for the actual place where 
this TABOO list gets applied, to recover a stand-alone usage 
example...

Any ideas are welcome :-)

Frank Rysanek

