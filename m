Return-Path: <linux-kernel-owner+w=401wt.eu-S1752651AbZBOHvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbZBOHvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 02:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZBOHvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 02:51:11 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:52887 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbZBOHvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 02:51:10 -0500
Date: Sun, 15 Feb 2009 08:53:01 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] scripts/setlocalversion: shorten the make time when using svn
Message-ID: <20090215075301.GA26237@uranus.ravnborg.org>
References: <1233821612-9548-1-git-send-email-cooloney@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233821612-9548-1-git-send-email-cooloney@kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 04:13:32PM +0800, Bryan Wu wrote:
> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> Don't bother doing `svn st` as it takes a retarded amount of time when
> the source is cold

Applied to kbuild-fixes.

	Sam
