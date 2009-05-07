Return-Path: <linux-kernel-owner+w=401wt.eu-S1761502AbZEGLjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761502AbZEGLjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 07:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbZEGLjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 07:39:33 -0400
Received: from tundra.namei.org ([65.99.196.166]:44611 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838AbZEGLjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 07:39:32 -0400
Date: Thu, 7 May 2009 21:37:01 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Chris Wright <chrisw@sous-sol.org>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-security-module@vger.kernel.org
Subject: Re: security: rename ptrace_may_access => ptrace_access_check
In-Reply-To: <20090507102015.GB8901@elte.hu>
Message-ID: <alpine.LRH.2.00.0905072135580.29806@tundra.namei.org>
References: <20090506235349.GC3756@redhat.com> <20090507002133.02D05FC39E@magilla.sf.frob.com> <20090507063606.GA15220@redhat.com> <20090507082027.GD12285@elte.hu> <20090507083102.GA20125@redhat.com> <20090507083851.GA19133@elte.hu> <20090507085742.GB3036@sequoia.sous-sol.org>
 <20090507090459.GE19133@elte.hu> <20090507092009.GC3036@sequoia.sous-sol.org> <alpine.LRH.2.00.0905071951530.29219@tundra.namei.org> <20090507102015.GB8901@elte.hu>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Ingo Molnar wrote:

> > Boot tested with SELinux.
> 
> thanks! Below are the two patches i wrote and tested.

Do you need these in your tree, or are they ok going into linux-next via 
mine?


-- 
James Morris
<jmorris@namei.org>
