Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbZBJRGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbZBJRGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 12:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbZBJRGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 12:06:11 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:53453 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbZBJRGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 12:06:09 -0500
Subject: Re: [RFC v13][PATCH 00/14] Kernel based checkpoint/restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Linus Torvalds <torvalds@osdl.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu>
References: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 09:05:47 -0800
Message-Id: <1234285547.30155.6.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-27 at 12:07 -0500, Oren Laadan wrote:
> Checkpoint-restart (c/r): a couple of fixes in preparation for 64bit
> architectures, and a couple of fixes for bugss (comments from Serge
> Hallyn, Sudakvev Bhattiprolu and Nathan Lynch). Updated and tested
> against v2.6.28.
> 
> Aiming for -mm.

Is there anything that we're waiting on before these can go into -mm?  I
think the discussion on the first few patches has died down to almost
nothing.  They're pretty reviewed-out.  Do they need a run in -mm?  I
don't think linux-next is quite appropriate since they're not _quite_
aimed at mainline yet.

-- Dave

