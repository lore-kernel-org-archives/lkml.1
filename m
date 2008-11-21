Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbYKUWCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbYKUWCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 17:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbYKUWCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 17:02:43 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:41407 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbYKUWCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 17:02:43 -0500
Date: Fri, 21 Nov 2008 23:01:29 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: use KECHO convenience echo
Message-ID: <20081121220129.GA18487@uranus.ravnborg.org>
References: <1225960295-30366-1-git-send-email-vapier@gentoo.org> <1225960295-30366-2-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225960295-30366-2-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 03:31:35AM -0500, Mike Frysinger wrote:
> Convert a few echos in the build system to new $(KECHO) so we get correct
> output according to build verbosity.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Applied both with a few mods. I will post full kbuild serie
tomorrow.

	Sam

