Return-Path: <linux-kernel-owner+w=401wt.eu-S1759406AbZKFP4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbZKFP4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 10:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759393AbZKFP4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 10:56:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35269 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759391AbZKFP4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 10:56:16 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs
To: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 02/10] fanotify: fscking all notification system
Date: Fri, 6 Nov 2009 16:54:13 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, linus-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org
References: <20091031184721.17244.16465.stgit@paris.rdu.redhat.com> <20091031184728.17244.73984.stgit@paris.rdu.redhat.com> <1257521505.3289.10.camel@dhcp231-106.rdu.redhat.com>
In-Reply-To: <1257521505.3289.10.camel@dhcp231-106.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911061654.13507.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 November 2009 04:31:45 pm Eric Paris wrote:
> I'm not hearing the negative feedback of the past and most everyone's
> questions and concerns have been addressed.  Everyone ok if I drop these
> into -next?

Some of the comments are outdated and don't match the code anymore.

Could the man pages please be removed from the comments, updated, and 
submitted separately (i.e., not as part of the kernel patches)?

Thanks,
Andreas
