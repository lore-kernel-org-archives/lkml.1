Return-Path: <linux-kernel-owner+w=401wt.eu-S1757562AbYHFNyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbYHFNyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbYHFNyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:54:14 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:1138 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361AbYHFNyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:54:13 -0400
Date: Wed, 6 Aug 2008 15:54:10 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       jmerkey@wolfmountaingroup.com,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Josh Boyer <jwboyer@gmail.com>
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Message-ID: <20080806135410.GA39185@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	jmerkey@wolfmountaingroup.com,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Josh Boyer <jwboyer@gmail.com>
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com> <Pine.LNX.4.64.0808051140150.6309@anakin> <33030.166.70.238.45.1217948565.squirrel@webmail.wolfmountaingroup.com> <200808060133.10457.nickpiggin@yahoo.com.au> <87r6926dsr.fsf@basil.nowhere.org> <4899A313.7020708@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4899A313.7020708@tmr.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 09:11:47AM -0400, Bill Davidsen wrote:
> I would suggest that if it meets coding standards and doesn't break 
> anything else it could be included in -mm (assume there's no objection 
> there) and let people beat on it there, with the assumption that unless 
> problems are found it will be promoted.

It's a little too early for that.  Right now it's at the phase "how to
make it better integrate with the kernel", with the use of existing
hooks, adding the needed hooks to be more complete, working as a
module, etc.  When that is done then the philosophical aspects can
come into play, but it's not there yet.

  OG.
