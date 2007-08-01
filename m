Return-Path: <linux-kernel-owner+w=401wt.eu-S1763315AbXHAIS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763315AbXHAIS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 04:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760783AbXHAISM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 04:18:12 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:23828 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760378AbXHAISJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 04:18:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=owQ6C6pGXdjIKV7bpSPLjg/BA5Al5Jwfaq5JnBY3it27/aLWIpuyE7CItI9s9PxB33F0E2IWmTAO1/xQ3ySH2joHWujdNIJzrve25HjURvE+MlK3VbmtfaVrQgKnndAO3KiiBdPv2yqApRUkwqL+tLRHo0/rL/obCmGhPcTK1F0=
Message-ID: <46B041B9.7050508@gmail.com>
Date: Wed, 01 Aug 2007 17:18:01 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: jeff@garzik.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, James.Bottomley@steeleye.com,
       edwintorok@gmail.com, axboe@kernel.dk, linux-scsi@vger.kernel.org
Subject: Re: [patch 1/4] Store interrupt value
References: <20070705194909.337398431@intel.com> <20070705130500.ad5f7739.kristen.c.accardi@intel.com>
In-Reply-To: <20070705130500.ad5f7739.kristen.c.accardi@intel.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> Use a stored value for which interrupts to enable.  Changing this allows
> us to selectively turn off certain interrupts later and have them 
> stay off.
> 
> Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
