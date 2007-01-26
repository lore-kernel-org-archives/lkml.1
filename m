Return-Path: <linux-kernel-owner+w=401wt.eu-S1161147AbXAZSWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161147AbXAZSWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161150AbXAZSWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:22:22 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:1619 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161147AbXAZSWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:22:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=upBEsQiT19kOytcsBRDWfGnEXbDMMRkCpQPl3qI/oJPtPSE8iyxCjw9E6ohowupsH59Of66CdumtVBdxa2cMsXD+tnzrrBoReaUDFqo9JraM1Kvpnx/zrkbfPRJt10bXB/6Q2muyvXZB8+wqL1FCdXOlYSL8VAuCVZhcNLIIjQg=
Message-ID: <6bffcb0e0701261022m5996540cyb75a2214328116fe@mail.gmail.com>
Date: Fri, 26 Jan 2007 19:22:18 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@osdl.org>,
       clg@fr.ibm.com, herbert@13thfloor.at, oleg@tv-sign.ru, daniel@hozac.com
In-Reply-To: <20070126181437.GA28927@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
	 <45BA3A8C.5020802@googlemail.com>
	 <20070126181437.GA28927@sergelap.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/01/07, Serge E. Hallyn <serue@us.ibm.com> wrote:
> Can you send me your series file for broken-out-2007-01-26-00-36.tar.gz,
> and I'll try to iron these out?  This is due to an older patch of
> Cedric's being applied at the same time as the preexit_task_namespaces
> one, and I just need to properly integrate them.

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-01-26-00-36.tar.gz

Series file is in the archive, but not in broken-out dir as usually.

$ tar zxvf broken-out-2007-01-26-00-36.tar.gz
$ ls
broken-out  broken-out-2007-01-26-00-36.tar.gz series

http://www.stardust.webpages.pl/files/tbf/euridica/mm-snapshot-2007-01-26/series

>
> thanks,
> -serge
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
