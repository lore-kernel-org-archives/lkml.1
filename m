Return-Path: <linux-kernel-owner+w=401wt.eu-S1758748AbYJJOip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbYJJOip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 10:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757487AbYJJOig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 10:38:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3782 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757425AbYJJOig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 10:38:36 -0400
Date: Fri, 10 Oct 2008 15:38:32 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: Liam Girdwood <lrg@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] WM8350 support
Message-ID: <20081010143832.GA1629@sirena.org.uk>
References: <20081006123254.GA9664@rakim.wolfsonmicro.main> <1223648664.6814.323.camel@dell-desktop.example.com> <20081010143148.GB4823@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010143148.GB4823@localdomain>
X-Cookie: He who hesitates is last.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 04:31:49PM +0200, Samuel Ortiz wrote:

> Sorry guys, but I havent had time to look at those patches yet.
> Liam, when would be the last moment for me to ACK/NACK them ?
> I expect to be able to do so during this weekend.

I've done some updates since the original posting incorporating feedback
from Liam and an update for the regulator API - do you want me to repost
with those?  They're sitting in:

	git://opensource.wolfsonmicro.com/linux-2.6-audioplus for-lrg
