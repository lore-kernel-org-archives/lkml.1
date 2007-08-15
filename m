Return-Path: <linux-kernel-owner+w=401wt.eu-S1759918AbXHOLMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918AbXHOLMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 07:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbXHOLMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 07:12:47 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:44488 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbXHOLMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 07:12:46 -0400
Date: Wed, 15 Aug 2007 13:14:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Blunck <jblunck@suse.de>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       opensuse-kernel@opensuse.org, opensuse@opensuse.org
Subject: Re: Testing the Current Upstream Kernel
Message-ID: <20070815111404.GA2783@uranus.ravnborg.org>
References: <20070815110850.GY12730@hasse.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070815110850.GY12730@hasse.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 01:08:51PM +0200, Jan Blunck wrote:
> (besides those we need for building a RPM).

Are these openSUSE specific or something we ought to apply to mainline?

If I sometimes are a bit reluctant aplying rpm specific patches it
is simply because I do not use the functionality myself and has
been bitten by the rpm/rpmfind thingy and other isssues
due to badly tested patches before.

	Sam
