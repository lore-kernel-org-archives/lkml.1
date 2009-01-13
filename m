Return-Path: <linux-kernel-owner+w=401wt.eu-S1760681AbZAMOiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681AbZAMOiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 09:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756408AbZAMOiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 09:38:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:56413 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745AbZAMOiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:38:07 -0500
Message-ID: <496CA71E.4050809@kernel.org>
Date: Tue, 13 Jan 2009 23:37:18 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       mingo@elte.hu, travis@sgi.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, akpm@linux-foundation.org, steiner@sgi.com,
       hugh@veritas.com
Subject: Re: [PATCHSET linux-2.6-x86:tip] x86: make percpu offsets zero-based
 on SMP
References: <1231843097-18003-1-git-send-email-tj@kernel.org>	 <496C717F.70204@kernel.org>	 <73c1f2160901130527s2d61f4ewf0725c3bf1b36a1a@mail.gmail.com>	 <496C9FB7.9050907@kernel.org> <73c1f2160901130626w5b808968vbc821bbf3f284424@mail.gmail.com>
In-Reply-To: <73c1f2160901130626w5b808968vbc821bbf3f284424@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Jan 2009 14:37:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
>> Any chance you can rebase those patches on top of mine?  If you don't
>> have time, just send them to me, I'll try to integrate them this week.
> 
> Are your patches available via git by chance?

Sure,

  http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=x86-percpu-zerobased
  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-percpu-zerobased

Thanks.

-- 
tejun
