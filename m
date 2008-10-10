Return-Path: <linux-kernel-owner+w=401wt.eu-S1759528AbYJJOYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528AbYJJOYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 10:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216AbYJJOYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 10:24:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:60757 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755807AbYJJOYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 10:24:33 -0400
Subject: Re: [PATCH 0/13] WM8350 support
From: Liam Girdwood <lrg@kernel.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081006123254.GA9664@rakim.wolfsonmicro.main>
References: <20081006123254.GA9664@rakim.wolfsonmicro.main>
Content-Type: text/plain
Date: Fri, 10 Oct 2008 15:24:24 +0100
Message-Id: <1223648664.6814.323.camel@dell-desktop.example.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-06 at 13:32 +0100, Mark Brown wrote:
> These patches against the regulator tree add initial support for the
> WM8350, a multi-function device with several subsystems targetted at
> embedded systems.  This series adds a core driver providing device acess
> under drivers/mfd and support for the PMIC functionality of the device
> via the regulator API.  Due to their use in the core some definitions
> for other parts of the device are also included - drivers for these will
> follow.
> 
> All the WM8350 drivers submitted here were originally written by Liam
> Girdwood with some updates from me for submission to mainline.
> 
> Samuel, as with the WM8400 are you OK with merging this via the
> regulator tree?

Samuel, are fine to Ack the MFD parts ?

Liam

