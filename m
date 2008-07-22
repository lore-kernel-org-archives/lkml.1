Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbYGVO2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbYGVO2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 10:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYGVO2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 10:28:02 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58905 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbYGVO2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 10:28:01 -0400
Subject: Re: 128 GiB memory question-- kernel only sees 64GiB?
From: Peter Zijlstra <peterz@infradead.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
In-Reply-To: <alpine.DEB.1.10.0807221019570.8455@p34.internal.lan>
References: <alpine.DEB.1.10.0807221019570.8455@p34.internal.lan>
Content-Type: text/plain
Date: Tue, 22 Jul 2008 16:28:03 +0200
Message-Id: <1216736883.7257.102.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-22 at 10:21 -0400, Justin Piszcz wrote:
> Hello,
> 
> To be able to utilize 128 GiB of memory on a host, does one need to enable 
> NUMA support? Currently only 64 GiB is showing up.
> 
> As far as machine name/motherboard type, I do not have this information 
> currently but I am told there are one or two of these boxes are running 
> CentOS 5.x and/or RHEL5/AS.

Sounds like you need to bug RH with that ;-)

> Is there something special you need to do to utilize all 128 GiB of 
> memory?

Does a recent kernel work for you? Also, you could at the very least
have mentioned your machine architecture; is it x86_64, ia64 or ppc64?

