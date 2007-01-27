Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151AbXA0Adn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbXA0Adn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 19:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbXA0Adm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 19:33:42 -0500
Received: from smtp.osdl.org ([65.172.181.24]:33821 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbXA0Adm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 19:33:42 -0500
Date: Fri, 26 Jan 2007 16:33:28 -0800
From: Andrew Morton <akpm@osdl.org>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Stephen Smalley" <sds@epoch.ncsc.mil>,
       "Chris Vance" <cvance@nai.com>, "Wayne Salamon" <wsalamon@nai.com>,
       "James Morris" <jmorris@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
Message-Id: <20070126163328.939922a3.akpm@osdl.org>
In-Reply-To: <6bffcb0e0701261523j3a84a357lad93260b5865c99d@mail.gmail.com>
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
	<45BA5A65.8040500@googlemail.com>
	<6bffcb0e0701261523j3a84a357lad93260b5865c99d@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jan 2007 00:23:47 +0100
"Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:

> On 26/01/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> > akpm@osdl.org napisał(a):
> > > The mm snapshot broken-out-2007-01-26-00-36.tar.gz has been uploaded to
> > >
> > >    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-01-26-00-36.tar.gz
> >
> > security/selinux/hooks.c: In function 'selinux_sysctl':
> > security/selinux/hooks.c:1440: error: 'ctl_table' has no member named 'de'
> > make[2]: *** [security/selinux/hooks.o] Error 1
> > make[1]: *** [security/selinux] Error 2
> > make: *** [security] Error 2
> >
> > Sysctl patches?
> 
> Thanks Eric, it builds fine.
> 

It doesn't for me.  What did you change?  Did you receive some unseen-by-me patch
from Eric?
