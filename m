Return-Path: <linux-kernel-owner+w=401wt.eu-S1764083AbYBZT6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764083AbYBZT6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 14:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbYBZT56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 14:57:58 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:32975 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764797AbYBZT54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 14:57:56 -0500
Date: Tue, 26 Feb 2008 20:58:02 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>, mikael.starvik@axis.com,
       dev-etrax@axis.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch v2] cris: proper defconfig setup
Message-ID: <20080226195802.GD31438@uranus.ravnborg.org>
References: <20080226172847.GB8287@cs181133002.pp.htv.fi> <20080226174703.GD8287@cs181133002.pp.htv.fi> <20080226180402.GH24124@axis.com> <20080226194453.GB31438@uranus.ravnborg.org> <20080226195257.GA4898@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226195257.GA4898@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Please name the tools that are that broken that they wouldn't apply this 
> patch correctly and don't claim my patch was broken (or shut up).

It is only one or two weeks ago we ended up with a zero size file
in the kernel tree - and I do not know why.
I just wanted to make sure we did not see this happen again.

	Sam
