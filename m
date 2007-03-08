Return-Path: <linux-kernel-owner+w=401wt.eu-S1750912AbXCHCrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750912AbXCHCrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 21:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbXCHCrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 21:47:33 -0500
Received: from watts.utsl.gen.nz ([202.78.240.73]:59795 "EHLO
	magnus.utsl.gen.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbXCHCrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 21:47:32 -0500
Message-ID: <45EF793C.1000700@vilain.net>
Date: Thu, 08 Mar 2007 15:47:24 +1300
From: Sam Vilain <sam@vilain.net>
User-Agent: Thunderbird 1.5.0.2 (X11/20060521)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru, pj@sgi.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, winget@google.com,
       containers@lists.osdl.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers
 on top of nsproxy!
References: <20070301133543.GK15509@in.ibm.com>	 <20070307174346.GA19521@sergelap.austin.ibm.com>	 <20070307180055.GC17151@in.ibm.com>	 <20070307205846.GB7010@sergelap.austin.ibm.com>	 <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>	 <m1odn4bs6n.fsf@ebiederm.dsl.xmission.com>	 <6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com>	 <45EF5A62.8000103@vilain.net>	 <6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com>	 <45EF5E71.7090101@vilain.net> <6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com>
In-Reply-To: <6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> Sorry, I think this statement is wrong, by the generally established
> meaning of the term namespace in computer science.
>   

Sorry, I didn't realise I was talking with somebody qualified enough to
speak on behalf of the Generally Established Principles of Computer Science.

>> Trying to extend the well-known term namespace to refer to thingsthat
>> are semantically equivalent namespaces is a useful approach, IMHO.
>>
>>     
> Yes, that would be true. But the kinds of groupings that we're talking
> about are supersets of namespaces, not semantically equivalent to
> them. To use Eric's "shoe" analogy from earlier, it's like insisting
> that we use the term "sneaker" to refer to all footware, including ski
> boots and birkenstocks ...
>   

I see it more like insisting that we use the term "clothing" to also
refer to "weapons" because for both of them you tell your body to "wear"
them in some game.

This is the classic terminology problem between substance and function. 
ie, some things share characteristics but does that mean they are the
same thing?

Look, I already agreed in the earlier thread that the term "namespace"
was being stretched beyond belief, yet instead of trying to be useful
about this you still insist on calling this sub-system specific stuff
the "container", and then go screaming that I am wrong and you are right
on terminology.

I've normally recognised[1] these three things as the primary feature
groups of vserver:

  - isolation
  - resource limiting
  - resource sharing

So I've got no problem with using "clothing" remaining for isolation and
"weapons" for resource sharing and limiting.  Or some other suitable terms.

Sam.

1. eg, http://utsl.gen.nz/talks/vserver/slide4c.html
