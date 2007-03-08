Return-Path: <linux-kernel-owner+w=401wt.eu-S932331AbXCHGKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbXCHGKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 01:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932353AbXCHGKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 01:10:16 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:58216 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331AbXCHGKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 01:10:13 -0500
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka
	containers on top of nsproxy!
From: Matt Helsley <matthltc@us.ibm.com>
To: Sam Vilain <sam@vilain.net>
Cc: Paul Menage <menage@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       ckrm-tech@lists.sourceforge.net, xemul@sw.ru,
       linux-kernel@vger.kernel.org, pj@sgi.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, winget@google.com,
       containers@lists.osdl.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       akpm@linux-foundation.org, dev@sw.ru
In-Reply-To: <45EF83CB.9080903@vilain.net>
References: <20070301133543.GK15509@in.ibm.com>
	 <20070307205846.GB7010@sergelap.austin.ibm.com>
	 <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>
	 <m1odn4bs6n.fsf@ebiederm.dsl.xmission.com>
	 <6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com>
	 <45EF5A62.8000103@vilain.net>
	 <6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com>
	 <45EF5E71.7090101@vilain.net>
	 <6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com>
	 <45EF793C.1000700@vilain.net>
	 <6599ad830703071857yf711921ja3440c4276bbe58e@mail.gmail.com>
	 <45EF83CB.9080903@vilain.net>
Content-Type: text/plain; charset=UTF-7
Organization: IBM Linux Technology Center
Date: Wed, 07 Mar 2007 22:10:09 -0800
Message-Id: <1173334209.13172.61.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-08 at 16:32 +-1300, Sam Vilain wrote:

+ADw-snip+AD4

+AD4 Kirill, 06032418:36+-03:
+AD4 +AD4 I propose to use +ACI-namespace+ACI naming.
+AD4 +AD4 1. This is already used in fs.
+AD4 +AD4 2. This is what IMHO suites at least OpenVZ/Eric
+AD4 +AD4 3. it has good acronym +ACI-ns+ACI.
+AD4 
+AD4 Right.  So, now I'll also throw into the mix:
+AD4 
+AD4   - resource groups (I get a strange feeling of d+AOk-j+AOA v+APo there)

+ADw-offtopic+AD4
Re: d+AOk-j+AOA v+APo: yes+ACE

It's like that Star Trek episode ... except we can't agree on the name
of the impossible particle we will invent which solves all our problems.
+ADw-/offtopic+AD4

At the risk of prolonging the agony I hate to ask: are all of these
groupings really concerned with +ACI-resources+ACI?

+AD4   - supply chains (think supply and demand)
+AD4   - accounting classes

CKRM's use of the term +ACI-class+ACI drew negative comments from Paul Jackson
and Andrew Morton about this time last year. That led to my suggestion
of +ACI-Resource Groups+ACI. Unless they've changed their minds...

+AD4 Do any of those sound remotely close?  If not, your turn :)

I'll butt in here: task groups? task sets? confuselets? +ADs)

Cheers,
	-Matt Helsley

