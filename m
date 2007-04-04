Return-Path: <linux-kernel-owner+w=401wt.eu-S1751612AbXDDRNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbXDDRNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbXDDRNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:13:04 -0400
Received: from gw.goop.org ([64.81.55.164]:54399 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbXDDRND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:13:03 -0400
Message-ID: <4613DC8C.8020801@goop.org>
Date: Wed, 04 Apr 2007 10:12:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/6] Re-enable VDSO by default with PARAVIRT
References: <20070404010655.400913479@goop.org> <20070404011453.193215073@goop.org> <200704041857.54535.ak@suse.de>
In-Reply-To: <200704041857.54535.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Hmm, that would break at least my test system until Jan's patch is applied.
>   

Boot with vdso=0?

    J
