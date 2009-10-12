Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbZJLKxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbZJLKxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755549AbZJLKxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:53:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:55904 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755454AbZJLKxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:53:33 -0400
Message-ID: <4AD30A6A.9000908@kernel.org>
Date: Mon, 12 Oct 2009 19:52:26 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Patch vs. percpu-next] Use this_cpu_xx in nmi handling
References: <alpine.DEB.1.10.0910071856400.3379@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0910071856400.3379@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 12 Oct 2009 10:52:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> From: Christoph Lameter <cl@linux-foundation.org>
> Subject: Use this_cpu_xx in nmi handling
> 
> this_cpu_inc/dec reduces the number of instructions needed.
> 
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

applied to percpu#for-next.

Thanks.

-- 
tejun
