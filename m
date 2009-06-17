Return-Path: <linux-kernel-owner+w=401wt.eu-S1762027AbZFQILX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762027AbZFQILX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 04:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbZFQILJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 04:11:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:58943 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbZFQILH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 04:11:07 -0400
Message-ID: <4A38A4D1.8010800@kernel.org>
Date: Wed, 17 Jun 2009 17:09:53 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Eric Dumazet <dada1@cosmosbay.com>, davem@davemloft.net
Subject: Re: [this_cpu_xx 01/11] Introduce this_cpu_ptr() and generic this_cpu_*
 operations
References: <20090605191819.376530498@gentwo.org> <20090605191850.441840884@gentwo.org> <4A2F40A3.5020602@kernel.org> <alpine.DEB.1.10.0906111109410.29827@gentwo.org> <4A31B8BF.30304@kernel.org> <alpine.DEB.1.10.0906121017430.13365@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0906121017430.13365@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 08:09:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Fri, 12 Jun 2009, Tejun Heo wrote:
> 
>>> They are usable for both as the following patches show.
>> Oops, sorry about that.  Got confused there.  :-)
> 
> Reviewed-by's or so would be appreciated. I almost got the allocators
> converted to use the ops as well but I want the simple stuff to be merged
> first.

Sorry about late reply.  Was hiding in my hole.  Will reply to the
orignal posting.

Thanks.

-- 
tejun
