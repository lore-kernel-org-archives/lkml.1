Return-Path: <linux-kernel-owner+w=401wt.eu-S1764451AbXE2I1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764451AbXE2I1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 04:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbXE2I1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 04:27:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60314 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbXE2I1B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 04:27:01 -0400
Date: Tue, 29 May 2007 10:26:05 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Al Viro <viro@ftp.linux.org.uk>
cc: Bodo Eggert <7eggert@gmx.de>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       David Miller <davem@davemloft.net>, satyam.sharma@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: double exclamation (!!) suckage in the kernel
In-Reply-To: <20070526165009.GT4095@ftp.linux.org.uk>
Message-ID: <Pine.LNX.4.58.0705291022400.27110@be10.lrz>
References: <8oOAk-4mP-3@gated-at.bofh.it> <8oPmF-5Fb-21@gated-at.bofh.it>
 <8p4OH-3N0-15@gated-at.bofh.it> <E1HrzHL-0000s2-Pv@be1.lrz>
 <20070526165009.GT4095@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+voa/jAFR3u4Tmi7fkgC6RaMwbuTIzIR0oFfC
 CtiMA2YQPJESx8ErWyrnWKxD8ZC+P5tLwkSyQL9ZX+u9nR+nPj
 pMZoK+7L3r1vOdvCQ5e0w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 May 2007, Al Viro wrote:

> On Sat, May 26, 2007 at 06:38:07PM +0200, Bodo Eggert wrote:
> > Not exactly, if(foo) is the same as if( (int) foo), which is not
> > guaranteed to result in non-null values for non-null pointers.
> 
> RTFStandard.

... and don´t forget half of it untill you look up the next thing.
Yes, obviously I misremembered "compares equal to" as "is".
