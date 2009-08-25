Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbZHYGGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbZHYGGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 02:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbZHYGGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 02:06:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58859 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbZHYGGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 02:06:00 -0400
Message-ID: <4A937EFA.5050706@cn.fujitsu.com>
Date: Tue, 25 Aug 2009 14:04:42 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Justin Mattock <justinmattock@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: system gets stuck in a lock during boot
References: <4A84345D.60506@gmail.com>	 <alpine.DEB.2.00.0908181926410.28398@gandalf.stny.rr.com>	 <4A8B4607.6090303@gmail.com> <4A8B5113.20102@cn.fujitsu.com>	 <4A8FA2BD.4030707@gmail.com> <4A91FDED.9050801@cn.fujitsu.com>	 <1251093523.7538.118.camel@twins> <4A922F82.9080000@cn.fujitsu.com>	 <1251096925.7538.121.camel@twins> <4A9251EB.8040805@gmail.com>	 <dd18b0c30908241219mdb76311t9334929f34f2c4c3@mail.gmail.com> <1251179444.7538.977.camel@twins>
In-Reply-To: <1251179444.7538.977.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2009-08-24 at 12:19 -0700, Justin Mattock wrote:
> 
>> O.K. I feel better, deleted
>> my system, and threw in a minimal built system
>> with only the bare essentials to boot.
>> (just to make sure things are correct).
>>
>> unfortunately after building rc6 I'm still hitting
>> this. really am not sure why this is happening.
> 
> Could you share your .config so we could have a try?
> 

Justin sent his config in an earlier mail in this thread.
But Steven didn't reproduce the bug with the config,
neither me.

And we don't receive another bug report regarding to this
crash.

