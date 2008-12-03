Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbYLCHXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbYLCHXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 02:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYLCHXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 02:23:08 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:34565 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbYLCHXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 02:23:08 -0500
Date: Wed, 3 Dec 2008 08:24:31 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] setlocalversion: print correct subversion revision
Message-ID: <20081203072431.GB980@uranus.ravnborg.org>
References: <1228251486-29275-1-git-send-email-jacmet@sunsite.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228251486-29275-1-git-send-email-jacmet@sunsite.dk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter.
On Tue, Dec 02, 2008 at 09:58:05PM +0100, Peter Korsgaard wrote:
> Output svn revision of latest change, instead of repo revision as thats
> what we're interested in (especially when working on a branch/tag).

Looks good. I will apply when I get on top of kbuild stuff which
I expect to do this weekend.

	Sam
