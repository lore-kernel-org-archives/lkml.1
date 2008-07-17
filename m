Return-Path: <linux-kernel-owner+w=401wt.eu-S1756870AbYGQKiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbYGQKiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 06:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbYGQKil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 06:38:41 -0400
Received: from main.gmane.org ([80.91.229.2]:40347 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbYGQKil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 06:38:41 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: el es <el_es_cr@yahoo.co.uk>
Subject: Re: Kernel version : what about s.yy.ww.tt scheme ?
Date: Thu, 17 Jul 2008 10:38:32 +0000 (UTC)
Message-ID: <loom.20080717T100809-415@post.gmane.org>
References: <loom.20080717T083755-676@post.gmane.org> <alpine.LNX.1.10.0807171140030.18697@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.151.87.91 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.16) Gecko/20080702 Firefox/2.0.0.16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh <at> medozas.de> writes:

> >The scheme to be s.yy.ww.tt, that is :
> >
> >s - series, as it is now (freedom to Linus to bump it to 3 when BKL is removed
> >for example ;) )
> >yy - two (in a hundred years, three) digits of the year
> >Now the interesting part begins which is
> >ww - the number of the week of the release. This will be between 1 and 52 (53)
> >tt - the number of the week of stable release. As above.
> 
> Interesting idea.
> 

Thanks :)

> -stable usually overlaps with master. But I don't like version
> numbers long as binutils and "2.8.30.9.01" have.

Yes, master and stable accumulate the same patches, I know. Only master takes
new code, whereas -stable does not.

This however tells how long did it take to produce the -stable release out of
Linus's release ;) And it does not break the current habits - just abuses them a
bit ;) 
And tells you how long the version was around there without another -stable
release too. Just by looking onto the version string, quick, sortable in
meaningful way, all sorts of pluses there ;)

IMO, the kernel is so mature already, and the development is so fast, and the
changes not always so fundamental, that the version in the old sense becomes
irrelevant - it is not the 2.4->2.6 transition days any more ;) 



Regards,
Lukasz (btw sorry I forgot to sign myself last time ;)



