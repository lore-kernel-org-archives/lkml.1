Return-Path: <linux-kernel-owner+w=401wt.eu-S1762001AbZFLL0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762001AbZFLL0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862AbZFLL03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:26:29 -0400
Received: from ozlabs.org ([203.10.76.45]:36210 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755675AbZFLL02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:26:28 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 3/6] cpumask: avoid playing with cpus_allowed in powernow-k8.c
Date: Fri, 12 Jun 2009 20:56:24 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, mark.langsdorf@amd.com
References: <20090611225928.E6FF4DDDA1@ozlabs.org> <20090611232517.GA32486@redhat.com>
In-Reply-To: <20090611232517.GA32486@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906122056.25333.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009 08:55:17 am Dave Jones wrote:
> This one clashes with some diffs I merged earlier in cpufreq.git.
> Can you rebase on top of that please?
> (The other two were fine).

OK, done.  Plus I have another (trivial) powernow-k8 patch (which still 
applies with offset).

Thanks!
Rusty.
