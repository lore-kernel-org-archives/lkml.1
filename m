Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbZEKRAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbZEKRAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756907AbZEKQ7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 12:59:40 -0400
Received: from gw.goop.org ([64.81.55.164]:52068 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633AbZEKQ7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 12:59:39 -0400
Message-ID: <4A08597A.6090408@goop.org>
Date: Mon, 11 May 2009 09:59:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, x86@kernel.org, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com
Subject: Re: [GIT PULL] xen: swiotlb support for Xen dom0
References: <1241741842-7966-1-git-send-email-jeremy@goop.org> <20090511123626N.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090511123626N.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> As I said before, I don't like such weak hacks added for dom0. We will
> merge dom0 support?
>   

That's in progress.  But they're largely the same hooks that ppc is 
using as well.

    J

