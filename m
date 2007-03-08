Return-Path: <linux-kernel-owner+w=401wt.eu-S965755AbXCHA6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965755AbXCHA6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 19:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965757AbXCHA6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 19:58:52 -0500
Received: from smtp-out.google.com ([216.239.45.13]:23984 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965755AbXCHA6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 19:58:51 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=qlI3aMRpRTpNVkOuZ7rt9Ts1hJieTgsmSmUHhDaEYiGXU7dyruln0i0/X8v5pMht7
	+T44C4vXu1pjtp+h9y9Fw==
Message-ID: <6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com>
Date: Wed, 7 Mar 2007 16:58:43 -0800
From: "Paul Menage" <menage@google.com>
To: "Sam Vilain" <sam@vilain.net>
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Cc: "Srivatsa Vaddagiri" <vatsa@in.ibm.com>, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru, pj@sgi.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, winget@google.com,
       containers@lists.osdl.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       akpm@linux-foundation.org
In-Reply-To: <45EF5E71.7090101@vilain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070301133543.GK15509@in.ibm.com>
	 <20070307174346.GA19521@sergelap.austin.ibm.com>
	 <20070307180055.GC17151@in.ibm.com>
	 <20070307205846.GB7010@sergelap.austin.ibm.com>
	 <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>
	 <m1odn4bs6n.fsf@ebiederm.dsl.xmission.com>
	 <6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com>
	 <45EF5A62.8000103@vilain.net>
	 <6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com>
	 <45EF5E71.7090101@vilain.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Sam Vilain <sam@vilain.net> wrote:
> But "namespace" has well-established historical semantics too - a way
> of changing the mappings of local * to global objects. This
> accurately describes things liek resource controllers, cpusets, resource
> monitoring, etc.

Sorry, I think this statement is wrong, by the generally established
meaning of the term namespace in computer science.

>
> Trying to extend the well-known term namespace to refer to things that
> are semantically equivalent namespaces is a useful approach, IMHO.
>

Yes, that would be true. But the kinds of groupings that we're talking
about are supersets of namespaces, not semantically equivalent to
them. To use Eric's "shoe" analogy from earlier, it's like insisting
that we use the term "sneaker" to refer to all footware, including ski
boots and birkenstocks ...

Paul
