Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbZDHWC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbZDHWC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 18:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbZDHWCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 18:02:47 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:51045 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbZDHWCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 18:02:47 -0400
Date: Thu, 9 Apr 2009 00:04:51 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Howells <dhowells@redhat.com>
Cc: jeremy@goop.org, mingo@elte.hu, akpm@linux-foundation.org, x86@kernel.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       nickpiggin@yahoo.com.au, tglx@linutronix.de, ysato@users.sourceforge.jp
Subject: Re: [PATCH] FRV: Use <asm-generic/pgtable.h> in NOMMU mode
Message-ID: <20090408220451.GA10861@uranus.ravnborg.org>
References: <20090408214014.GA10366@uranus.ravnborg.org> <20090408205610.GA9970@uranus.ravnborg.org> <20090408184455.GB332@uranus.ravnborg.org> <21081.1239214221@redhat.com> <20090408183011.24150.43310.stgit@warthog.procyon.org.uk> <24317.1239216477@redhat.com> <26753.1239225955@redhat.com> <27338.1239227337@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27338.1239227337@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 10:48:57PM +0100, David Howells wrote:
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > --follow is needed to follow renames when doing git log.
> 
> So what's '-M' for?

'-M' is about creating diffs.
If you need more details you need to ask on the git-list.

I only know how to use git - not so much why.

	Sam
