Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbYBAS2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbYBAS2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbYBAS2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:28:44 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:52597 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414AbYBAS2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:28:43 -0500
Date: Fri, 1 Feb 2008 19:28:44 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Dave Haywood <tla@oak.selfip.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: Section mismatches in kernel v2.6.24-6314-g24e1c13 build
Message-ID: <20080201182844.GA14759@uranus.ravnborg.org>
References: <47A35FC2.9030701@oak.selfip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A35FC2.9030701@oak.selfip.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave.
On Fri, Feb 01, 2008 at 06:06:58PM +0000, Dave Haywood wrote:
> PROBLEM: Section mismatches in kernel v2.6.24-6314-g24e1c13 build
> 
> Hi,
> 
>  I see the folllowing section mismatches in the latest Linus kernel git 
>  tree build:
...

Thanks for the report. These are being worked on but it looks like
we will have a few dozen left when we reach -rc1.

	Sam
