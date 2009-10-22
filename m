Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbZJVQGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbZJVQGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 12:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbZJVQGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 12:06:46 -0400
Received: from mail-a02.ithnet.com ([217.64.83.97]:58799 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752392AbZJVQGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 12:06:45 -0400
X-Sender-Authentication: net64
Date: Thu, 22 Oct 2009 18:06:46 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       David Rientjes <rientjes@google.com>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Frans Pop <elendil@planet.nl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: page allocation failure message kernel 2.6.31.4 (tty-related)
Message-Id: <20091022180646.3f098911.skraw@ithnet.com>
In-Reply-To: <20091022125120.GN11778@csn.ul.ie>
References: <20091020153838.665bc39c.skraw@ithnet.com>
	<alpine.LRH.2.00.0910211848510.20992@twin.jikos.cz>
	<alpine.DEB.2.00.0910211409390.20010@chino.kir.corp.google.com>
	<20091022105902.GM11778@csn.ul.ie>
	<84144f020910220536k61d43e95x802c2391459e4305@mail.gmail.com>
	<20091022125120.GN11778@csn.ul.ie>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009 13:51:20 +0100
Mel Gorman <mel@csn.ul.ie> wrote:
>
> What I'm going to do is prepare a set that assembles all the possible patches
> that fix the variety of errors and get people to retest to make sure we catch
> what is relevant, what isn't and what bugs (if any) are left. I should have
> the set ready by the end of the day.

Feel free to send, I got lots of those messages, so a change should be very
visible for me.

-- 
Regards,
Stephan
