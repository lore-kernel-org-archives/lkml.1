Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbYCQPEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbYCQPEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 11:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbYCQPEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 11:04:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726AbYCQPEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 11:04:43 -0400
Message-ID: <47DE8870.1020503@redhat.com>
Date: Mon, 17 Mar 2008 11:04:16 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andrew Morton <akpm@linux-foundation.org>, ananth@in.ibm.com,
       jkenisto@us.ibm.com, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com, prasanna@in.ibm.com, shaohua.li@intel.com,
       davem@davemloft.net, fche@redhat.com
Subject: Re: [PATCH -mm 1/5] list.h: add list_singleton
References: <47DAE2C4.2060303@redhat.com>	 <20080314140007.a7b495d7.akpm@linux-foundation.org>	 <47DAFAA2.20302@redhat.com> <1205620596.6422.8.camel@lappy>
In-Reply-To: <1205620596.6422.8.camel@lappy>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Peter Zijlstra wrote:
>>> So I guess we can proceed with your list_singleton(), but I'd just like to
>>> flag this possible confusion, see what people think..
> 
> May I kindly ask to please not use the singleton name like this. It does
> not implement the singleton pattern and will be a great confusion for
> everybody who expects it to.

Indeed.

I have some other candidates.
- list_single
- list_has_one
- list_one

Could you tell me which or some other name you recommend?

Thanks,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

