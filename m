Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYALXPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYALXPo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 18:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbYALXPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 18:15:34 -0500
Received: from mga10.intel.com ([192.55.52.92]:40976 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751064AbYALXPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 18:15:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,276,1196668800"; 
   d="scan'208";a="497850988"
Message-ID: <47894999.8060505@linux.intel.com>
Date: Sat, 12 Jan 2008 15:13:29 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew.Morton@hera.kernel.org
Subject: Re: Top 10 kernel oopses for the week ending January 12th, 2008
References: <47890B65.80804@linux.intel.com> <20080112222322.GE17276@does.not.exist>
In-Reply-To: <20080112222322.GE17276@does.not.exist>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> 
> All the other reports only contain the plain trace. Is there any way to 
> get more information whether the former is a pattern or not, and to
> get this information somehow displayed on the webpage?

IF the kernel prints that its tainted or whatever it'll be shown, as well
as the exact versions etc etc if they are there.
Sadly none of this information is there prior to 2.6.24-rc4.
(I wonder if the patch to print this should be put in -stable ;-)
