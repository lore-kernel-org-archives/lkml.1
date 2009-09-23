Return-Path: <linux-kernel-owner+w=401wt.eu-S1752673AbZIWPmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbZIWPmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 11:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbZIWPmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 11:42:45 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:54018 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbZIWPmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 11:42:44 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: fanotify as syscalls
Date: Wed, 23 Sep 2009 16:42:43 +0100
User-Agent: KMail/1.9.10
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Jamie Lokier <jamie@shareable.org>, Eric Paris <eparis@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "alan@linux.intel.com" <alan@linux.intel.com>,
       "hch@infradead.org" <hch@infradead.org>
References: <20090912094110.GB24709@ioremap.net> <200909230939.34003.tvrtko.ursulin@sophos.com> <20090923133232.5577688d@infradead.org>
In-Reply-To: <20090923133232.5577688d@infradead.org>
MIME-Version: 1.0
Message-Id: <200909231642.43563.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 23/09/2009 16:42:43,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 23/09/2009 16:42:44,
	Serialize complete at 23/09/2009 16:42:44
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 September 2009 12:32:32 Arjan van de Ven wrote:
> On Wed, 23 Sep 2009 09:39:33 +0100
>
> Tvrtko Ursulin <tvrtko.ursulin@sophos.com> wrote:
> > Lived with it because there was no other option. We used LSM while it
> > was available for modules but then it was taken away.
>
> ... at which point you could have submitted your LSM module for
> inclusion... you'd be the first (and only?) Anti Virus vendor that
> would be in the mainline kernel.. speaking of competitive advantage,
> coming out of the box in all distributions.
>
> sadly this road hasn't been chosen....

It has, but since what we had wasn't acceptable the road was long and it 
turned into fanotify. Which is not only about anti-malware (hello Christoph) 
so I think this sub-thread is going off-topic.

Tvrtko
