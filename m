Return-Path: <linux-kernel-owner+w=401wt.eu-S1760549AbZJIJiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760549AbZJIJiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760457AbZJIJiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:38:17 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:54430 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760443AbZJIJiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:38:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SaDxPYWeNcwxoQupGlnZ9HKUEok7ysVewWiKThyUU4o+riwqc2DJAv13IQKFjybrvh
         bClaF8aYhURgmS6zHVbKDjb7HFiPJ83aw0t3dCIaGmmd5C/SRo7qwUJxXlDv4iGcJw57
         U3zSka4HxDcogAdLmeIRTePyqJzIXnRlbWmao=
Date: Fri, 9 Oct 2009 11:36:27 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       johannes@sipsolutions.net
Subject: Re: [2.6.32-rc3] iwlagn lost connection after s2ram (with warnings)
Message-ID: <20091009093627.GA26955@Pilar.aei.mpg.de>
References: <20091007142031.GA7495@Pilar.aei.mpg.de> <1255023883.26521.13298.camel@rc-desk> <20091008181534.GA19621@Pilar.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091008181534.GA19621@Pilar.aei.mpg.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu  8.Oct'09 at 20:15:34 +0200, Carlos R. Mafra wrote:
> I will keep you informed if it happens again.

Yes, it just happened again. I saved the dmesg, but it looks identical
to the one I already posted.

So the problem is still there (with 2.6.32-rc3+ now), but I am very afraid
of trying a bisection marathon here, because it does not happen everytime.

Anything else I could try to help debbuging this?
