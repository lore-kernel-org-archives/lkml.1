Return-Path: <linux-kernel-owner+w=401wt.eu-S1765072AbXEVSq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765072AbXEVSq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 14:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756441AbXEVSqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 14:46:51 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:40209 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862AbXEVSqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 14:46:50 -0400
Date: Tue, 22 May 2007 13:46:32 -0500
To: Tsutomu OWA <tsutomu.owa@toshiba.co.jp>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCH] powerpc 2.6.21-rt6: revert spider_net
Message-ID: <20070522184632.GL5921@austin.ibm.com>
References: <yyi646l6pmr.wl@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yyi646l6pmr.wl@toshiba.co.jp>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 08:53:32PM +0900, Tsutomu OWA wrote:
> 
> Hi Ingo and Thomas,
>
> To revert spider_net.c to original one as it turns out that the patch 

As the spidernet maintainer, I had not forwarded the previous patch
upstream; it should not have been applied.

--linas

