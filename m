Return-Path: <linux-kernel-owner+w=401wt.eu-S1760923AbXGCQAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760923AbXGCQAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbXGCQAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:00:17 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:36215 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129AbXGCQAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:00:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gXv6JgebYSegFhnhxwPHaqAKkVPZKa3x70wKp2XeVS6eaPhH3dJmUZbmf1o8IQoEqQsin/lEtos1GsaBTXo0pNa/umZ4jcRqhM3dLY/vWEfmy6h0J/vvhE47Oo28O/du5aQtEtobBfB1j0HdTiUoAktRfId/f1GQKUEIhWyufGo=
Message-ID: <6bffcb0e0707030900k66defc1bi3ff8e70b23a050bf@mail.gmail.com>
Date: Tue, 3 Jul 2007 18:00:14 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Ni@m" <niam.niam@gmail.com>
Subject: Re: pci hidden behind transparent bridge
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pci@atrey.karlin.mff.cuni.cz
In-Reply-To: <a9e22dff0707021209i13718d72p84160c4d3ff89e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a9e22dff0707021209i13718d72p84160c4d3ff89e4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/07/07, Ni@m <niam.niam@gmail.com> wrote:
> Hi! I noticed such message:
>
> "PCI: Bus #07 (-#0a) is hidden behind transparent bridge #06 (-#06)
> (try 'pci=assign-busses')
> Please report the result to linux-kernel to fix this permanently"
>
> on my
> Linux niam 2.6.22-rc6-cfs-v18 #6 Mon Jul 2 20:19:25 EEST 2007 i686
> Intel(R) Celeron(R) M processor 1.50GHz GenuineIntel GNU/Linux
>
> What does it mean??

Is this a regressions?

Have you tried to boot kernel with "pci=assign-busses" param?

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
