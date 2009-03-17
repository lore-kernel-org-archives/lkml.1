Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbZCQV1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbZCQV1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 17:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756454AbZCQV1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 17:27:24 -0400
Received: from ozlabs.org ([203.10.76.45]:47273 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756996AbZCQV1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 17:27:24 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PULL] x86 cpumask work
Date: Wed, 18 Mar 2009 07:57:19 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Mike Travis <travis@sgi.com>
References: <200903121453.45163.rusty@rustcorp.com.au> <200903171450.34549.rusty@rustcorp.com.au> <20090317105121.GJ6477@elte.hu>
In-Reply-To: <20090317105121.GJ6477@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903180757.19964.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 March 2009 21:21:21 Ingo Molnar wrote:
> looks perfect. Should i apply or do you want to send a pull 
> request?

Just apply, if that's OK.

BTW, I'm about to post the cpufreq and acpi cpumask-games-removal patches
again.  If DaveJ and Len don't NAK them, do you want to apply them, or prefer
a pull against cpus4096 (they're really only tangentially related to that
effort tho).

Thanks,
Rusty.
