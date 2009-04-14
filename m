Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbZDNVHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbZDNVHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbZDNVH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:07:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753762AbZDNVH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:07:26 -0400
Date: Tue, 14 Apr 2009 13:59:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, hpa@zytor.com,
       ebiederm@xmission.com, garyhade@us.ibm.com, lcm@us.ibm.com,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] irq: correct CPUMASKS_OFFSTACK typo -v2
Message-Id: <20090414135958.36c79836.akpm@linux-foundation.org>
In-Reply-To: <49E4F513.1060709@kernel.org>
References: <200903231757.53709.rusty@rustcorp.com.au>
	<20090323165921.GA7559@us.ibm.com>
	<200903241553.58209.rusty@rustcorp.com.au>
	<20090402013108.GB7103@us.ibm.com>
	<20090404003520.GA8847@us.ibm.com>
	<20090410215515.GC7242@us.ibm.com>
	<20090411065510.GA11799@elte.hu>
	<20090413220321.GA11098@us.ibm.com>
	<49E4146C.7060507@kernel.org>
	<49E4162A.3060701@kernel.org>
	<20090414131711.GA4403@elte.hu>
	<49E4F513.1060709@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009 13:41:55 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> irq

Speaking of which, could someone please take a look at
http://www.gossamer-threads.com/lists/linux/kernel/1060580?do=post_view_threaded#1060580
?

Thanks.
