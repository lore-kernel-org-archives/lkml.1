Return-Path: <linux-kernel-owner+w=401wt.eu-S2992838AbXDDKh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992838AbXDDKh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 06:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992839AbXDDKh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 06:37:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51998 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992838AbXDDKh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 06:37:27 -0400
Date: Wed, 4 Apr 2007 11:36:24 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, ego@in.ibm.com, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>, dipankar@in.ibm.com,
       dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com,
       Roland McGrath <roland@redhat.com>
Subject: Re: utrace merge
Message-ID: <20070404103624.GA509@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, ego@in.ibm.com,
	paulmck@us.ibm.com, torvalds@linux-foundation.org,
	linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
	Oleg Nesterov <oleg@tv-sign.ru>, dipankar@in.ibm.com,
	dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com,
	Roland McGrath <roland@redhat.com>
References: <20070402053457.GA9076@in.ibm.com> <20070402061612.GA7072@elte.hu> <20070403120104.GB29308@in.ibm.com> <200704032134.29720.rjw@sisk.pl> <20070403132427.88308b59.akpm@linux-foundation.org> <20070404100644.GC19120@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404100644.GC19120@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 12:06:44PM +0200, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > urgh, I screwed up, sorry.
> > 
> > utrace-prep-2 reverts a bit of the underlying tree so that the utrace 
> > patches (which are against mainline) don't throw a tremendous reject 
> > which has to be fixed each time I pull Roland's tree.  I'm supposed to 
> > reapply that change after the utrace patches but forgot.
> 
> btw., how about pushing utrace to v2.6.22, is anything big holding that 
> up? (other than Roland's modesty, which we should gently but firmly 
> ignore in this case =B-)

a) lots of architecture support
b) lots of overengineered and obsfucated code
c) missing public information

I've also not gotten any feedback to my ages old review and the issues
don't seem to be addressed either.



