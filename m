Return-Path: <linux-kernel-owner+w=401wt.eu-S1422885AbXBGWDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422885AbXBGWDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 17:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422816AbXBGWDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 17:03:08 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:37717 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422885AbXBGWDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 17:03:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WoNeuTpnUOJkP1Jfuco86MXMHEoII5iCCCi6GlxCa8nBqm2Y0S5X0FRrcnqoJMnPW+YY9rGeYbFyeDx6vCuN4R3YhsBWEwb4Sk62oZ3t/cyJ8leTARbpPw4HSqNgqxfGMPjxfgEoLVnxsJPdTiV1PrxXXVhaA7BM+P35meQofaQ=
Message-ID: <6bffcb0e0702071403v767681edk2179fdb968b57e5a@mail.gmail.com>
Date: Wed, 7 Feb 2007 23:03:04 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: mm snapshot broken-out-2007-02-06-16-59.tar.gz uploaded
Cc: linux-kernel@vger.kernel.org, "Cedric Le Goater" <clg@fr.ibm.com>
In-Reply-To: <45CA0065.80705@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702070059.l170xPY0002614@shell0.pdx.osdl.net>
	 <45CA0065.80705@fr.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 07/02/07, Cedric Le Goater <clg@fr.ibm.com> wrote:
> akpm@linux-foundation.org wrote:
> > The mm snapshot broken-out-2007-02-06-16-59.tar.gz has been uploaded to
> >
> >    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-02-06-16-59.tar.gz
>
> I'm having download issues : wrong modes :(
>
> ftp.kernel.org:/pub/linux/kernel/people/akpm/mm> ls
> ...
> -rw-rw-r--    1 536      536           248 Jan 28 08:31 broken-out-2007-01-28-00-31.tar.gz.sign
> -rw-rw-r--    1 536      536           248 Jan 28 08:31 broken-out-2007-01-28-00-31.tar.sign
> -rw-r-----    1 536      536       4065035 Feb 07 00:59 broken-out-2007-02-06-16-59.tar.bz2
> -rw-r-----    1 536      536           248 Feb 07 00:59 broken-out-2007-02-06-16-59.tar.bz2.sign
> -rw-r-----    1 536      536       5000290 Feb 07 00:59 broken-out-2007-02-06-16-59.tar.gz
> -rw-r-----    1 536      536           248 Feb 07 00:59 broken-out-2007-02-06-16-59.tar.gz.sign
> -rw-r-----    1 536      536           248 Feb 07 00:59 broken-out-2007-02-06-16-59.tar.sign
>

I still can't wget it...

Can you upload a new snapshot (broken-out-2007-02-06-16-59 + latest
80+ patches)?

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
