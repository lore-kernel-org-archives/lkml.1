Return-Path: <linux-kernel-owner+w=401wt.eu-S932260AbYBOLUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbYBOLUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 06:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbYBOLT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 06:19:58 -0500
Received: from ns1.suse.de ([195.135.220.2]:53943 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678AbYBOLT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 06:19:58 -0500
To: pierre.peiffer@bull.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24-mm1 0/8] (resend) IPC: code rewrite
From: Andi Kleen <andi@firstfloor.org>
References: <20080212161340.200976067@bull.net>
Date: Fri, 15 Feb 2008 12:19:57 +0100
In-Reply-To: <20080212161340.200976067@bull.net> (pierre peiffer's message of "Tue\, 12 Feb 2008 17\:13\:40 +0100")
Message-ID: <p73y79mzcte.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pierre.peiffer@bull.net writes:

> 	This is a resend of the first part of the patchset sent 2 weeks
> ago. This is the part about the IPC which (again) proposes to consolidate
> some part of the existing code.
>
> 	It does not change the behavior of the existing code, but
> improves it in term of readability and maintainability as it consolidates it
> a little. As there was no objection, I think you can include them in your 
> -mm tree.
>
> 	The patchset applies on top of "2.6.24-mm1 + previous patches about
> IPC" sent the last days (ie Nadia's patches + mine).

While I have not read everything in detail from a quick overview
the whole patch series looks like a nice and valuable cleanup to me.

I was a bit sceptical about all the interface enhancements your original
patchkit had, but this one looks just fine.

-Andi
