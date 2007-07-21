Return-Path: <linux-kernel-owner+w=401wt.eu-S936094AbXGUODX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936094AbXGUODX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 10:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762941AbXGUODM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 10:03:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:49962 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762944AbXGUODL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 10:03:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uInxXT12jD3vijCgGLip7u/H3B6GL+rstHYy0j/EIQXfTUqIxNRKufs0VvE6Jd5fv5Krdh+8cNx1ojFkkahUlICMv15KLr3KZueDDkwUdT9Uk4Hdcv8FMEXrzSRqUzwUdag6qCSUMSZiie66UXXKR+3YygjTYysIMfN7yzD25O4=
Message-ID: <3cea2ee30707210703p5865ef77j103eb9e7499dd95b@mail.gmail.com>
Date: Sat, 21 Jul 2007 10:03:09 -0400
From: "Andrew Gallatin" <gallatin@gmail.com>
To: "Jan-Bernd Themann" <ossthema@de.ibm.com>
Subject: Re: [RFC 0/1] lro: Generic Large Receive Offload for TCP traffic
Cc: netdev <netdev@vger.kernel.org>, "Christoph Raisch" <raisch@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, "Marcus Eder" <meder@de.ibm.com>,
       "Thomas Klein" <tklein@de.ibm.com>,
       "Stefan Roscher" <stefan.roscher@de.ibm.com>,
       "David Miller" <davem@davemloft.net>, "Jeff Garzik" <jeff@garzik.org>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
In-Reply-To: <200707201741.45079.ossthema@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707201741.45079.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Jan-Bernd Themann <ossthema@de.ibm.com> wrote:
> Hi,
>
> Thanks a lot for your comments so far.
> This generic LRO patch differs from the last one in several points.
> A new interface for a "receive in pages" mode has been added and tested
> with an eHEA prototype. Seems to work well.
>
> Does this extended interface seem to be sufficient?

Thank you for this!

At least for me, I find it is best to try to use an interface rather
than simply reading a diff.  So I will port Myri10GE to use the new
interface so that I can give better feedback,  I'll try my best to do
this  by early next week.

Thank you again,

Drew
