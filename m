Return-Path: <linux-kernel-owner+w=401wt.eu-S1758958AbYAJNRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958AbYAJNRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 08:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbYAJNRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 08:17:32 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:40441 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710AbYAJNRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 08:17:31 -0500
Date: Thu, 10 Jan 2008 08:16:59 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080110131659.GF10230@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Tuomo Valkonen <tuomov@iki.fi>, linux-kernel@vger.kernel.org
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <18307.42821.166376.732473@stoffel.org> <slrnfo7auq.6m2.tuomov@jolt.modeemi.cs.tut.fi> <871w8r6ruc.fsf@barad-dur.regala.cx> <slrnfo9lqk.17l.tuomov@jolt.modeemi.cs.tut.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <slrnfo9lqk.17l.tuomov@jolt.modeemi.cs.tut.fi>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 02:16:52PM +0000, Tuomo Valkonen wrote:
> On 2008-01-09, Mathieu SEGAUD <mathieu.segaud@regala.cx> wrote:
> > fix your hardware clock then
> 
> It displays just the right time. On boot anyway. (Linux has had some
> serious problems keeping the time after the switch from 2.6.7 to 2.6.14,
> advanding even 15 minutes a day -- that ntpd doesn't seem to be able 
> to keep up with -- requiring running adjtimexconfig every now and
> then for new settings. But the cmos clock displays the right time.)

What do you mean by "on boot"?  Which boot message, precisely?  Is the
time printed before or after e2fsck is run, and by which program?

				- Ted
