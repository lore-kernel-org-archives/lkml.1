Return-Path: <linux-kernel-owner+w=401wt.eu-S1422779AbXCGRyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422779AbXCGRyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422957AbXCGRyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:54:08 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60656 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422746AbXCGRx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:53:58 -0500
Date: Wed, 7 Mar 2007 23:30:55 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Paul Menage <menage@google.com>, ebiederm@xmission.com, sam@vilain.net,
       akpm@linux-foundation.org, pj@sgi.com, dev@sw.ru, xemul@sw.ru,
       containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070307180055.GC17151@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070301133543.GK15509@in.ibm.com> <6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com> <20070307173031.GC2336@in.ibm.com> <20070307174346.GA19521@sergelap.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307174346.GA19521@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 11:43:46AM -0600, Serge E. Hallyn wrote:
> I still think the complaint was about terminology, not implementation.

I don't think that is what http://lkml.org/lkml/2007/2/12/426 conveyed!

> They just didn't want you calling them containers.

Yes that too.

> > Anyway, summarizing on "why nsproxy", the main point (I think) is about
> > using existing abstraction in the kernel.

s/abstraction/"implementation detail" then :)

> But nsproxy is not an abstraction, it's an implementation
> detail/optimization.  


-- 
Regards,
vatsa
