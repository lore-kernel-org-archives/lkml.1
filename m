Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbYFDEu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbYFDEu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 00:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbYFDEuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 00:50:15 -0400
Received: from dgate10.fujitsu-siemens.com ([80.70.172.49]:53247 "EHLO
	dgate10.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751129AbYFDEuO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 00:50:14 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:From:Organization:To:Subject:Date:User-Agent:Cc:
   References:In-Reply-To:MIME-Version:Content-Type:
   Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RN0Kz/DO/ZEmTsx/T5JR/hwQWhhhIZeP3/x2Yf3P1JQRhX6mfzL7hx/B
   K1QfuPbu5l/Llq0f3LNjZgwi/D0N4EYAqMkAylCGwQeXGutEE9GfAi9Fe
   bM6jamHztUb9OmX;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.27,586,1204498800"; 
   d="scan'208";a="16190180"
X-IronPort-AV: E=Sophos;i="4.27,586,1204498800"; 
   d="scan'208";a="34458634"
From: Rainer Koenig <Rainer.Koenig@fujitsu-siemens.com>
Organization: IP BC E SW OS
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: Who can backport the AHCI driver to older kernels
Date: Wed, 4 Jun 2008 06:50:12 +0200
User-Agent: KMail/1.9.5
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806031247.42046.Rainer.Koenig@fujitsu-siemens.com> <200806031352.31940.elendil@planet.nl> <18501.13296.224958.291840@harpo.it.uu.se>
In-Reply-To: <18501.13296.224958.291840@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806040650.12683.Rainer.Koenig@fujitsu-siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mikael,

Am Dienstag, 3. Juni 2008 14:07 schrieb Mikael Pettersson:
> Redhat seems to regularly backport the entire libata layer
> to at least 2.6.18 (RHEL5) and maybe also 2.6.9 (RHEL4).

Yes indeed we get perfect support from both Red Hat and SUSE for their 
enterprise level distribution. I already got a driver kit for the 
SLES10 kernel. The problem is that the targeted market is not willing
to use enterprise level (which means spend money for subscription) 
distros. They go for the "free" (as in free beer) distros and suffer 
from missing drivers. 

Regards
Rainer
-- 
Dipl.-Inf. (FH) Rainer Koenig
Project Manager Linux Business Clients
Dept. IP BC E SW OS

Fujitsu Siemens Computers 
Bürgermeister-Ullrich-Str. 100
86199 Augsburg
Germany

Telephone: +49-821-804-3321
Telefax:   +49-821-804-2131
Mail:      mailto:Rainer.Koenig@fujitsu-siemens.com 

Internet         www.fujitsu-siemens.com
Company Details  www.fujitsu-siemens.com/imprint.html
