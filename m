Return-Path: <linux-kernel-owner+w=401wt.eu-S1762135AbXFKIph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762135AbXFKIph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 04:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbXFKIp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 04:45:29 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:20762 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbXFKIp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 04:45:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pafZ9NqxoV+WtsIhrPM5bbW4ED1K/UMo81Ws4S+w7kytrdiYmEAkVpi7bE7wBqrEjQs0ayx8vKwsdjQ3DjFvc/VSKr0LUhAeCdFouNEfCma7qIppg9BBihhCdJEtLAXlzFLkzN8aBqfKU8anPS15beDrd3UyN+KG1HlKY9+REJI=
Message-ID: <98df96d30706110145i290dad15lb83b5d46524bd803@mail.gmail.com>
Date: Mon, 11 Jun 2007 17:45:27 +0900
From: "Hiro Yoshioka" <lkml.hyoshiok@gmail.com>
Reply-To: hyoshiok@miraclelinux.com
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [RFD] Documentation/HOWTO translated into Japanese
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Tsugikazu Shibata" <tshibata@ab.jp.nec.com>,
       linux-kernel@vger.kernel.org, m-ikeda@ds.jp.nec.com,
       "Hiro Yoshioka" <hyoshiok@miraclelinux.com>
In-Reply-To: <20070611060906.GC914@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com>
	 <20070611115557.4340f45e.kamezawa.hiroyu@jp.fujitsu.com>
	 <20070611060906.GC914@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Shibata san's contribution was really great. I was impressed too.

I think the important point is that Shibata san let the
linux kernel community knows the translation work has been done
and ask the feedback.

I think this two way communication is very important.

On 6/11/07, Greg KH <gregkh@suse.de> wrote:
> On Mon, Jun 11, 2007 at 11:55:57AM +0900, KAMEZAWA Hiroyuki wrote:
> >
> > Hi, thank you for your work. I was impressed.
> >
> > BTW, how about adding following lines (both in Japanese and English) ?
> > ==
> > This is translated "HOWTO" documentation. Original "HOWTO" is maintaind by
> > Greg Kroah-Hartman <greg@kroah.com> and linux kernal mailing list.
> > And this one is maintained by Tsugikazu Shibata <tsugikazu.shibata@jp.nec.com>
> > and JF Projet <www.linux.or.jp/JF>. Because original HOWTO documentation itself
> > is being updated day and night, this file may contain old sentences. Please contact
> > JF project if you find problems in translation.
> >
> > It is guaranteed that this file is just a translation and doesn't contains any
> > additional information, sentences. If you want to update "HOWTO", please update
> > English version first. Don't fork from original if you update this file.
> >
> > Last Updated: 2007/06/04  Version: 2.6.21
> > ==
> >
> > not worth writing ?
>
> That sounds fine with me, and would be good to have.  I also have no
> problem also CC:ing anyone who wants to translate this file with patches
> that happen to modify the originals.  That way they can easily keep up
> with the minor number of changes that happen over time.

I think that some members of YLUG (Yokohama Linux Users Group)
may help to review the translations. :-)

Regards,
  Hiro
-- 
Hiro Yoshioka
mailto:hyoshiok at miraclelinux.com
