Return-Path: <linux-kernel-owner+w=401wt.eu-S933718AbXGQR6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718AbXGQR6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933391AbXGQR6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:58:01 -0400
Received: from smtp-out.google.com ([216.239.45.13]:39950 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765192AbXGQR6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:58:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=F/bW0F9HTPwg+kqmo39UFRJ1zO7E1HzpcDR1n6ECv0KwhdAKmoy1pgri6yzesUp/i
	ZhFFRyZc1xaAFXhwSE3Qg==
Message-ID: <6599ad830707171057x54ad9e8ay94bd23b7086d2efe@mail.gmail.com>
Date: Tue, 17 Jul 2007 10:57:49 -0700
From: "=?ISO-2022-JP?B?UGF1bCAoGyRCSnVOXBsoQikgTWVuYWdl?=" 
	<menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: Containers: css_put() dilemma
Cc: balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, xemul@sw.ru,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       akpm@linux-foundation.org
In-Reply-To: <20070717105509.95d72b35.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469BBE00.8000709@linux.vnet.ibm.com>
	 <469C2792.6050009@linux.vnet.ibm.com>
	 <6599ad830707161935n69776f1t98292fc9990f4766@mail.gmail.com>
	 <20070717070031.GA22410@linux.vnet.ibm.com>
	 <6599ad830707170018p180cb7dfr53e609fd0b186e30@mail.gmail.com>
	 <469C99D1.7090807@linux.vnet.ibm.com>
	 <6599ad830707170849v11fe8cecs6d172cd38d247e09@mail.gmail.com>
	 <469CFF2B.1080702@linux.vnet.ibm.com>
	 <6599ad830707171044u38c0a940r12d2bc80b475ead4@mail.gmail.com>
	 <20070717105509.95d72b35.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/07, Paul Jackson <pj@sgi.com> wrote:
> Paul M wrote:
> > In fact, that's exactly what the release agent
> > patch already does.
>
> I'm feeling lazy ;)  What's the Subject of that
> patch, for my easy searching?

"Support for automatic userspace release agents"

Paul
