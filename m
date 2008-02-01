Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbYBAQb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbYBAQb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 11:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbYBAQbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 11:31:22 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:57476 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbYBAQbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 11:31:21 -0500
Date: Fri, 1 Feb 2008 08:31:20 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: Yi Yang <yi.y.yang@intel.com>
cc: tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 2.6.24] x86: add sysfs interface for cpuid module
In-Reply-To: <1201562058.12722.9.camel@yangyi-dev.bj.intel.com>
Message-ID: <alpine.DEB.1.00.0802010830560.7110@twinlark.arctic.org>
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>  <1201043126.3861.5.camel@yangyi-dev.bj.intel.com> <1201562058.12722.9.camel@yangyi-dev.bj.intel.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

why do we need another kernel cpuid reading method when sched_setaffinity 
exists and cpuid is available in ring3?

-dean
