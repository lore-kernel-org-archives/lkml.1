Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbZBYC4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbZBYC4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 21:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757542AbZBYC4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 21:56:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:56209 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727AbZBYC4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 21:56:38 -0500
Message-ID: <49A4B35B.6090701@kernel.org>
Date: Wed, 25 Feb 2009 11:56:27 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yinghai@kernel.org>, rusty@rustcorp.com.au, tglx@linutronix.de,
       x86@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       jeremy@goop.org, cpw@sgi.com, nickpiggin@yahoo.com.au,
       ink@jurassic.park.msu.ru
Subject: Re: [PATCHSET x86/core/percpu] improve the first percpu chunk	allocation
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <20090224201718.GE28772@elte.hu> <20090224205105.GA19460@elte.hu> <20090224211659.GA3687@elte.hu> <49A4ABAC.90602@kernel.org>
In-Reply-To: <49A4ABAC.90602@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Feb 2009 02:56:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello, Ingo.
> 
> Patches posted to fix the build failure and warning.  Patches are also
> available in the usual git tree.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

Hmm... kernel.org is slow today.  It hasn't been mirrored yet.  The
commit ID is d325100504f1d0c296a1fbfef558deaa655e2240.  If it doesn't
show up please pull from master.kernel.org.

Thanks.

-- 
tejun
