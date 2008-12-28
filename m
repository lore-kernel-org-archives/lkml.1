Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbYL1WgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbYL1WgY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 17:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757261AbYL1WgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 17:36:08 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:36091 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203AbYL1WgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 17:36:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=n/uovkvcQ/RxXUCH9CwssNgx70y1xxWzXliE1/UzkUpWsM4deTNgF04+6E0HX8kn54
         We1VrTNXxIYg/F+QyZR+YlWvf65ErPiVIFgCOQpU+iVXWGEgcnVRulw5ju48+jHajgck
         ShOGB/ryOQni8PyXElIuhNqViiiq0ImOvnfA4=
Date: Sun, 28 Dec 2008 23:35:39 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 byteorder.h: use __asm__/__inline__ for userspace
Message-ID: <20081228223534.GA6287@joi>
References: <1230360604-6711-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230360604-6711-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 01:50:04AM -0500, Mike Frysinger wrote:
> Use __asm__/__inline__ rather than asm/inline for all the functions
> exported to userspace.

Why? I can't find anything related in Documentation/.

Marcin
