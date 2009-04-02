Return-Path: <linux-kernel-owner+w=401wt.eu-S1763452AbZDBQTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763452AbZDBQTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760217AbZDBQSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:18:43 -0400
Received: from gw.goop.org ([64.81.55.164]:48350 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761715AbZDBQSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:18:42 -0400
Message-ID: <49D4E55F.8010406@goop.org>
Date: Thu, 02 Apr 2009 09:18:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, akpm@osdl.org,
       frankeh@watson.ibm.com, virtualization@lists.osdl.org, riel@redhat.com,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       linux-mm@kvack.org, hugh@veritas.com
Subject: Re: [patch 0/6] Guest page hinting version 7.
References: <20090327150905.819861420@de.ibm.com>	<200903281705.29798.rusty@rustcorp.com.au>	<20090329162336.7c0700e9@skybase>	<200904022232.02185.nickpiggin@yahoo.com.au> <20090402175249.3c4a6d59@skybase>
In-Reply-To: <20090402175249.3c4a6d59@skybase>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:
>> I still think this needs much more justification.
>>     
>  
> Ok, I can understand that. We probably need a KVM based version to show
> that benefits exist on non-s390 hardware as well.
>   

BTW, there was a presentation at the most recent Xen summit which makes 
use of CMM ("Satori: Enlightened Page Sharing", 
http://www.xen.org/files/xensummit_oracle09/Satori.pdf).

    J
