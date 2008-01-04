Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbYADQwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbYADQwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 11:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbYADQw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 11:52:26 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:3007 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbYADQwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 11:52:25 -0500
Date: Fri, 4 Jan 2008 17:52:14 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>, yi.y.yang@intel.com, pavel@ucw.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm][PATCH] base: Change power/wakeup output from "" to "unsupported" if wakeup feature isn't supported by a device
Message-ID: <20080104165214.GA30672@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	David Brownell <david-b@pacbell.net>, yi.y.yang@intel.com,
	pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20080104160933.B01D81FBAB5@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <Pine.LNX.4.44L0.0801041136490.4078-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0801041136490.4078-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 11:38:29AM -0500, Alan Stern wrote:
> How about changing it to say "unavailable"?  That doesn't imply 
> permanence.

How about not changing a userland-visible interface gratuitously?

  OG.

