Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbYIRKmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbYIRKmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 06:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYIRKmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 06:42:12 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:61461 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbYIRKmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 06:42:11 -0400
In-Reply-To: <20080918112713.75872c95@bull.net>
References: <20080915100406.342e027a@bull.net>	<OF39C3BF0F.17B60FAA-ONC12574C8.002AE138-C12574C8.002B6422@de.ibm.com> <20080918112713.75872c95@bull.net>
Subject: Re: [PATCH HACK] powerpc: quick hack to get a functional eHEA with hardirq
 preemption, eHCA is close
X-KeepSent: D7842B7A:ADC47EED-C12574C8:003A2CB3;
 type=4; name=$KeepSent
To: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: Benjamin Herrenschmidt <bherren@au1.ibm.com>, gilles.carry@ext.bull.net,
       Jan-Bernd Themann <THEMANN@de.ibm.com>, jean-pierre.dion@bull.net,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linux-rt <linux-rt-users@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, netdev@vger.kernel.org,
       Thomas Q Klein <TKLEIN@de.ibm.com>, tinytim@us.ibm.com,
       Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>
X-Mailer: Lotus Notes Release 8.0.1 HF105 April 10, 2008
Message-ID: <OFD7842B7A.ADC47EED-ONC12574C8.003A2CB3-C12574C8.003AC948@de.ibm.com>
From: Christoph Raisch <RAISCH@de.ibm.com>
Date: Thu, 18 Sep 2008 12:42:05 +0200
X-MIMETrack: Serialize by Router on D12ML067/12/M/IBM(Release 8.0.1|February 07, 2008) at
 18/09/2008 12:42:06
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sebastien Dugue <sebastien.dugue@bull.net> wrote on 18.09.2008 11:27:13:

>
>   It would be really interresting to know if the eHCA exhibits the same
> problem under -rt as it's the only other user of the ibmebus.
> Unfortunately I don't have the hardware to test.
>

eHCA is very close from the interrupt generation and handling perspective,
so yes, could be an issue there as well.


Gruss / Regards
Christoph Raisch


