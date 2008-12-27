Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbYL0Syj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbYL0Syj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 13:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbYL0Sya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 13:54:30 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:58913 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbYL0Sy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 13:54:29 -0500
Date: Sat, 27 Dec 2008 19:56:04 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] headers_install.pl: autoconvert asm/inline/volatile to __xxx__
Message-ID: <20081227185604.GA10442@uranus.ravnborg.org>
References: <1230364498-31620-1-git-send-email-vapier@gentoo.org> <1230366195-23989-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230366195-23989-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 03:23:15AM -0500, Mike Frysinger wrote:
> Headers in userspace should be using the __xxx__ form of the asm, inline,
> and volatile keywords.  Since people like to revert these things without
> realizing what's going on, have the headers install step autoconvert these
> keywords.

Applied

	Sam

