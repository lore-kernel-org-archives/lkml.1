Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbZDTRIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbZDTRIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 13:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbZDTRIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 13:08:37 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:35559 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbZDTRIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 13:08:37 -0400
Date: Mon, 20 Apr 2009 13:00:34 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: AIM9 from 2.6.22 to 2.6.29
In-Reply-To: <20090418154207.1260.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0904201300140.1585@qirst.com>
References: <alpine.DEB.1.10.0904161616001.17864@qirst.com> <20090418154207.1260.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Apr 2009, KOSAKI Motohiro wrote:

> > Here is a list of AIM9 results for all kernels between 2.6.22 2.6.29:
> >
> > Significant regressions:
> >
> > creat-clo
> > page_test
>
> I'm interest to it.
> How do I get AIM9 benchmark?

Checkout reaim9 on sourceforge.
>
> and, Can you compare CONFIG_UNEVICTABLE_LRU is y and n?


Sure.

