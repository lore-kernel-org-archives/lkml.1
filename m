Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318Ab0BPU3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 15:29:12 -0500
Received: from fieldses.org ([174.143.236.118]:54234 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933193Ab0BPU3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 15:29:09 -0500
Date: Tue, 16 Feb 2010 15:29:47 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Nikola Ciprich <extmaillist@linuxbox.cz>
Cc: Harry Edmon <harry@atmos.washington.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org, nikola.ciprich@linuxbox.cz
Subject: Re: 2.6.32.2 - WARNING: at lib/kref.c:43 kref_get+0x,23/0x2b()
Message-ID: <20100216202947.GF26292@fieldses.org>
References: <4B4F5A00.4060604@atmos.washington.edu> <20100122150325.6ad12428.akpm@linux-foundation.org> <20100127190522.GB18278@fieldses.org> <4B60C5D4.6070000@atmos.washington.edu> <20100202162228.GD4293@fieldses.org> <20100216182248.GA4922@nik-comp.linuxbox.cz> <20100216202121.GE26292@fieldses.org> <20100216202720.GB4922@nik-comp.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100216202720.GB4922@nik-comp.linuxbox.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 09:27:20PM +0100, Nikola Ciprich wrote:
> > Nothing yet.  I'm taking another look.
> > 
> > Do you know what the most recent version was where you did *not* see
> > these warnings?
> well, actually I decided I'll bisect this one no matter what, so hopefully
> we'll see soon :)
> I'll report

That would be fantastic, thanks.  What test-case are you using?

Any partial information ("xxxx good, xxxx bad") would also be useful.

--b.
