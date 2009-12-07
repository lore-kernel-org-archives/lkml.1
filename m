Return-Path: <linux-kernel-owner+w=401wt.eu-S932301AbZLGTfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbZLGTfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 14:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932203AbZLGTfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 14:35:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932191AbZLGTfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 14:35:14 -0500
Date: Mon, 7 Dec 2009 11:35:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Al Viro <viro@ftp.linux.org.uk>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/19] untangling do_mremap(), part 1
In-Reply-To: <20091207184438.GH14381@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.0912071134300.3560@localhost.localdomain>
References: <E1NHUdk-0007ul-Oc@ZenIV.linux.org.uk> <alpine.LFD.2.00.0912070911290.3560@localhost.localdomain> <20091207184438.GH14381@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Dec 2009, Al Viro wrote:
> 
> Which David? ;-)  All sparc-related bits seem to have been ACKed by
> davem.

That's the David I meant. I've seen the ack, but the acks weren't actually 
quoted in your latest series.

			Linus
