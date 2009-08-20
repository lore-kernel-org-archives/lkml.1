Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbZHTDSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbZHTDSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 23:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbZHTDSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 23:18:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56329 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbZHTDSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 23:18:39 -0400
Message-ID: <4A8CC03A.4010807@cn.fujitsu.com>
Date: Thu, 20 Aug 2009 11:17:14 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: akpm@linux-foundation.org, bblum@andrew.cmu.edu,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 1/8] Revert commit 8827c288feb7810185aa7c2e37537202fc709869
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com>	 <20090818235812.22531.76212.stgit@menage.mtv.corp.google.com>	 <4A8CB62F.8030504@cn.fujitsu.com>	 <6599ad830908191941x6ee47d58x295c29f80f8c624c@mail.gmail.com>	 <4A8CBEDC.6010709@cn.fujitsu.com> <6599ad830908192013p328a2256o8c807a160e25a9a3@mail.gmail.com>
In-Reply-To: <6599ad830908192013p328a2256o8c807a160e25a9a3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Wed, Aug 19, 2009 at 8:11 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>> As you said, the 2 patches differ just in using different var/func
>> names, so rebasing shouldn't be hard but maybe a bit boring.
>>
> 
> Yes - it's a fair amount of work for no real gain.
> 

Ok, I won't insist on how it should be done.

