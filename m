Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab0CEOzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 09:55:53 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42233 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752516Ab0CEOzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 09:55:51 -0500
Date: Fri, 5 Mar 2010 09:55:51 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm@lists.linux-foundation.org,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Mark Brown <broonie@sirena.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH] PM: add dpm_use_runtime_{suspend, resume}
 helper functions
In-Reply-To: <201003042219.54135.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1003050954160.1677-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010, Rafael J. Wysocki wrote:

> I agree with all of the comments above, hopefully addessed them in the new
> patch below.

It looks good.  One small thing: You probably should change the
kerneldoc for pm_generic_runtime_idle to match the changes in
pm_generic_runtime_{suspend,resume}.  I must have missed that one.

Alan Stern

