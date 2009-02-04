Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbZBDQBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbZBDQBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 11:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbZBDQBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 11:01:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:52749 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbZBDQBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 11:01:07 -0500
Subject: Re: [GIT PULL -tip v3] fix 39 'make headers_check' warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4989B6F7.4060004@redhat.com>
References: <1232287474.3130.19.camel@localhost.localdomain>
	 <20090118185635.GA30514@elte.hu> <497445B6.7030606@redhat.com>
	 <20090119110153.GA8321@uranus.ravnborg.org>	 <497469AC.2030107@redhat.com>
	 <3f9a31f40901232216r4656776mfac4388485180a60@mail.gmail.com>
	 <4989A60E.9000809@redhat.com>
	 <1233760678.3180.2.camel@localhost.localdomain>
	 <4989B6F7.4060004@redhat.com>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 21:30:12 +0530
Message-Id: <1233763212.3523.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 17:40 +0200, Avi Kivity wrote:
> Jaswinder Singh Rajput wrote:
> > hmm. it seems you are looking at old patches which we already dropped.
> >
> > Please check the latest patches and kbuild at:
> > http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-x86.git;a=shortlog;h=core/header-fixes
> >
> >   
> 
> These are the <linux/types.h> patches.  I was talking about the 
> CONFIG_X86 in the headers.
> 
> If there's such a patch in the URL you posted, please point to it directly.
> 

All CONFIG_* patches are dropped.

--
JSR

