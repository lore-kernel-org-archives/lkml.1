Return-Path: <linux-kernel-owner+w=401wt.eu-S1765727AbXILVj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765727AbXILVj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 17:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756939AbXILVjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 17:39:52 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35348 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756786AbXILVjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 17:39:51 -0400
Date: Wed, 12 Sep 2007 16:39:50 -0500 (CDT)
From: Brent Casavant <bcasavan@sgi.com>
Reply-To: Brent Casavant <bcasavan@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: O_NOLINK for open()
In-Reply-To: <46E85528.3010405@zytor.com>
Message-ID: <20070912163645.E5573@pkunk.americas.sgi.com>
References: <20070912144128.D5573@pkunk.americas.sgi.com> <46E85528.3010405@zytor.com>
Organization: Silicon Graphics, Inc.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007, H. Peter Anvin wrote:

> Brent Casavant wrote:

> > 	http://marc.info/?l=linux-kernel&m=93032806224160&w=2
> 
> This link talks about file flags handling.  I don't see the relevance to
> this problem at all.  However, this is a very long thread, so if there
> is anything specific that you want to point to, then please elucidate.

Oops, my mistake -- I pasted the wrong URL.  I meant this thread, this
post in particular:

	http://marc.info/?l=linux-kernel&m=88937224115435&w=2

Still, O_NOLINK would seem to be a valuable addition, and greatly
simplify secure temporary file creation.

Brent

-- 
Brent Casavant                          All music is folk music.  I ain't
bcasavan@sgi.com                        never heard a horse sing a song.
Silicon Graphics, Inc.                    -- Louis Armstrong
