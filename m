Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbXCHAxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbXCHAxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 19:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbXCHAxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 19:53:14 -0500
Received: from watts.utsl.gen.nz ([202.78.240.73]:45277 "EHLO
	magnus.utsl.gen.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbXCHAxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 19:53:13 -0500
Message-ID: <45EF5E71.7090101@vilain.net>
Date: Thu, 08 Mar 2007 13:53:05 +1300
From: Sam Vilain <sam@vilain.net>
User-Agent: Thunderbird 1.5.0.2 (X11/20060521)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, akpm@linux-foundation.org,
       pj@sgi.com, dev@sw.ru, xemul@sw.ru, containers@lists.osdl.org,
       winget@google.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] resource control file system - aka containers on
 top of nsproxy!
References: <20070301133543.GK15509@in.ibm.com>	 <6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com>	 <20070307173031.GC2336@in.ibm.com>	 <20070307174346.GA19521@sergelap.austin.ibm.com>	 <20070307180055.GC17151@in.ibm.com>	 <20070307205846.GB7010@sergelap.austin.ibm.com>	 <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>	 <m1odn4bs6n.fsf@ebiederm.dsl.xmission.com>	 <6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com>	 <45EF5A62.8000103@vilain.net> <6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com>
In-Reply-To: <6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> But "namespace" has well-established historical semantics too - a way
> of changing the mappings of local names to global objects. This
> doesn't describe things liek resource controllers, cpusets, resource
> monitoring, etc.
>
> Trying to extend the well-known term namespace to refer to things that
> aren't namespaces isn't a useful approach, IMO.
>
> Paul
>   

But "namespace" has well-established historical semantics too - a way
of changing the mappings of local * to global objects. This
accurately describes things liek resource controllers, cpusets, resource
monitoring, etc.

Trying to extend the well-known term namespace to refer to things that
are semantically equivalent namespaces is a useful approach, IMHO.

Sam.

