Return-Path: <linux-kernel-owner+w=401wt.eu-S1763356AbXGFTFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763356AbXGFTFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 15:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbXGFTEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 15:04:52 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:51243 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbXGFTEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 15:04:52 -0400
Date: Fri, 6 Jul 2007 15:04:41 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Dan Kegel <dank@kegel.com>, linux-kernel@vger.kernel.org,
       Robert Walsh <rjwalsh@durables.org>
Subject: Re: Valgrinding the kernel?
Message-ID: <20070706190441.GA12246@c2.user-mode-linux.org>
References: <a71bd89a0707052114u28fed408h4326913c502a43ac@mail.gmail.com> <468DD6A5.4020705@goop.org> <20070706172513.GD10670@c2.user-mode-linux.org> <468E834E.6020906@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468E834E.6020906@goop.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2007 at 11:00:46AM -0700, Jeremy Fitzhardinge wrote:
> >UML is cloning a thread in order to test the host's ptrace.  However,
> >it looks like valgrind is branching to 0x9 for some reason.
> >  
> 
> How far into the run does this happen?  Immediately, or after a while?

This is pretty much immediately.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
