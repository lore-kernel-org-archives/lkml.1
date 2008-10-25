Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbYJYWGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbYJYWGh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 18:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbYJYWCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 18:02:41 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:50941 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065AbYJYWCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 18:02:40 -0400
Date: Sun, 26 Oct 2008 00:02:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] setlocalversion: dont include svn change count
Message-ID: <20081025220227.GA27785@uranus.ravnborg.org>
References: <1224971030-4280-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224971030-4280-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2008 at 05:43:50PM -0400, Mike Frysinger wrote:
> The number of pending changes is pretty useless, so encoding it into the
> version is just annoying by the constant shuffle in corresponding modules.

Applied to kbuild-fixes.git

Will push out soon.

	Sam
