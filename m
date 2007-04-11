Return-Path: <linux-kernel-owner+w=401wt.eu-S1751998AbXDKKMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbXDKKMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 06:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbXDKKMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 06:12:50 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:22202 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbXDKKMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 06:12:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ddMVvJ0L6CV1M6p/lDHU+fvsS8jir9LbTIiWY+dMSTbzbgRN3h7lMalwwyI9RWwuVvR5/Y1hw1qdzce8OiPHgL6MEm0bq6r8GMejw77+Ra2/eVJnVuFDR+qV0yPkUH1FsY60lVSawZt4cDPQfvoYQ8tOhs2BXc2MH3xdCYUyRT4=
Message-ID: <5767b9100704110312t3ce53bd6u1dbb50c79eeb8d7@mail.gmail.com>
Date: Wed, 11 Apr 2007 18:12:48 +0800
From: "Conke Hu" <conke.hu@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH] ahci.c: remove non-existing SB600 raid id
Cc: "Jeff Garzik" <jeff@garzik.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
In-Reply-To: <461CB1B1.9030207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5767b9100704110254s16566ce7n147aa578181d84e6@mail.gmail.com>
	 <461CB1B1.9030207@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/07, Tejun Heo <htejun@gmail.com> wrote:
> Conke Hu wrote:
> >    SB600 RAID and SB600 SATA is the same controller and share the
> > same PCI ID 0x4380. There is such PCI ID 0x4381.
>
> I assume 'no' is missing in the last sentence.  :-)
>
> --
> tejun
>

Oh, sorry :(
so, should I re-send the mail?

conke
