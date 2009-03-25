Return-Path: <linux-kernel-owner+w=401wt.eu-S1764142AbZCYRnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764142AbZCYRnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763493AbZCYRnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:43:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53798 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763737AbZCYRnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:43:13 -0400
Date: Wed, 25 Mar 2009 17:44:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "D. Matt Placek" <dmattplacek@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ioctl interface to wait on VT switch
Message-ID: <20090325174409.3d29dbed@lxorguk.ukuu.org.uk>
In-Reply-To: <8044b6ad0903250951w3b843e6etd6ec866404dbe455@mail.gmail.com>
References: <8044b6ad0903250951w3b843e6etd6ec866404dbe455@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> if there is a better approach feedback is invited.  It would simply be
> nice not to have to spawn 60 threads just to wait for a console
> switch, and this is a pretty minor addition to the VT system.

Needs a signed-off-by line (see Documentation/SubmittingPatches) and
something seems to mashed up the format by the time the file arrived here
(your additions are misindented in the patch file)

But other than that, well this is clearly a feature worth adding.
