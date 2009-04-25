Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbZDYH0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbZDYH0V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 03:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbZDYH0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 03:26:04 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:41613 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbZDYH0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 03:26:02 -0400
Date: Sat, 25 Apr 2009 09:28:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Makefile:  "make prepare" should be "make modules_prepare"
Message-ID: <20090425072810.GB27747@uranus.ravnborg.org>
References: <alpine.LFD.2.00.0904241233220.22684@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904241233220.22684@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 12:35:23PM -0400, Robert P. J. Day wrote:
> 
> Correct the Makefile help text to read "make modules_prepare".
> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 
> ---
> 
>   i'm fairly sure that the correct target for configuring external
> module builds is "modules_prepare," no?

Correct - applied.

	Sam
