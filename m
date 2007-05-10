Return-Path: <linux-kernel-owner+w=401wt.eu-S1761342AbXEJWVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761342AbXEJWVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756909AbXEJWVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:21:31 -0400
Received: from smtprelay04.ispgateway.de ([80.67.18.16]:56180 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100AbXEJWVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:21:30 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: john stultz <johnstul@us.ibm.com>, Tomas Janousek <tjanouse@redhat.com>
Subject: Re: [PATCH] Introduce boot based time
Date: Fri, 11 May 2007 00:22:54 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tsmetana@redhat.com, riel@redhat.com
References: <1178302732.5929.23.camel@localhost.localdomain> <200705102149.01714.ioe-lkml@rameria.de> <1178827376.6011.11.camel@localhost.localdomain>
In-Reply-To: <1178827376.6011.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705110022.55862.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John and Tomas, 

On Thursday 10 May 2007, john stultz wrote:
> I'm not sure I follow this. 
> 
> total_sleep_time stores seconds. So on 32bit systems that's 130some
> years, so it shouldn't be an issue.
> 
> Is the reason you want it to be a ktime is because you want a way to
> keep sub-second sleep granularity?

No, I'm just overworked and getting sloppy :-/ 

Sorry for the noise...

Best regards

Ingo Oeser
