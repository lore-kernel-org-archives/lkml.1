Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbXCJJMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbXCJJMG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 04:12:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932627AbXCJJMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 04:12:06 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53304 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932290AbXCJJMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 04:12:02 -0500
Date: Sat, 10 Mar 2007 01:11:15 -0800
From: Paul Jackson <pj@sgi.com>
To: Sam Vilain <sam@vilain.net>
Cc: menage@google.com, ebiederm@xmission.com, serue@us.ibm.com,
       vatsa@in.ibm.com, akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru,
       containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] resource control file system - aka containers on
 top of nsproxy!
Message-Id: <20070310011115.dbeddf39.pj@sgi.com>
In-Reply-To: <45F271D3.3040909@vilain.net>
References: <20070301133543.GK15509@in.ibm.com>
	<6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com>
	<20070307173031.GC2336@in.ibm.com>
	<20070307174346.GA19521@sergelap.austin.ibm.com>
	<20070307180055.GC17151@in.ibm.com>
	<20070307205846.GB7010@sergelap.austin.ibm.com>
	<6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>
	<m1odn4bs6n.fsf@ebiederm.dsl.xmission.com>
	<6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com>
	<45EF5A62.8000103@vilain.net>
	<6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com>
	<45EF5E71.7090101@vilain.net>
	<20070308202713.34de89ed.pj@sgi.com>
	<45F271D3.3040909@vilain.net>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam wrote:
> But when you apply this to something like cpusets, it gets a little abstract.

Just a tad abstract <grin>.

Thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
