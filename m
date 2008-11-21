Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbYKUU7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbYKUU7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 15:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbYKUU7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 15:59:24 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:41952 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbYKUU7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 15:59:23 -0500
Date: Fri, 21 Nov 2008 21:58:09 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] scripts/mkcompile_h: kill output in silent mode
Message-ID: <20081121205809.GA14970@uranus.ravnborg.org>
References: <1225960282-30342-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225960282-30342-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 03:31:22AM -0500, Mike Frysinger wrote:
> The mkcompile_h script does `echo` regardless of silent mode the make is
> running at, so have it respect $quiet from kbuild and only echo when not in
> silent mode.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Applied.

	Sam
