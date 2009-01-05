Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbZAEUHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbZAEUHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 15:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbZAEUHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 15:07:09 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:60597 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbZAEUHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 15:07:08 -0500
Date: Mon, 5 Jan 2009 21:08:48 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       sparclinux <sparclinux@vger.kernel.org>
Subject: Re: [PATCH] sparc: make proces_ver_nack a bit more readable
Message-ID: <20090105200848.GD6204@uranus.ravnborg.org>
References: <20090105181922.GA25622@uranus.ravnborg.org> <alpine.DEB.1.10.0901051428370.27085@gandalf.stny.rr.com> <alpine.DEB.1.10.0901051437490.27085@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901051437490.27085@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 02:42:59PM -0500, Steven Rostedt wrote:
> 
> Impact: clean up
> 
> The code in process_ver_nack is a little obfuscated. This change
> makes it a bit more readable by humans. It removes the complex
> if statement and replaces it with a cleaner flow of control.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>

And I can confirm the warning has dismissed with this patch.

	Sam
