Return-Path: <linux-kernel-owner+w=401wt.eu-S1758516AbZE2Lsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516AbZE2Lsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 07:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758099AbZE2Lso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 07:48:44 -0400
Received: from mx03.syneticon.net ([78.111.66.105]:54414 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757841AbZE2Lsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 07:48:43 -0400
Message-ID: <4A1FCBAB.2030100@wpkg.org>
Date: Fri, 29 May 2009 13:48:59 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: gregkh@suse.de, jeremy@goop.org, davem@davemloft.net, jaswinder@kernel.org
Subject: Re: Xen is a feature
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

> On Thu, May 28, 2009 at 05:45:34PM -0700, Jeremy Fitzhardinge wrote:
>> Mozilla and Debian are hosted on Xen systems.
> 
> A tiny data point about these domains.  They are hosted by osuosl.org,
> which uses xen systems running with the current dom0 patch set.  Because
> those patches are out-of-tree, they have a hard time updating kernel
> versions, and generally lag kernel.org releases by a lot, which is not
> always a good thing.
> 
> So getting the dom0 patches into mainline will make their lives much
> easier, and more secure.

I know at least a couple of mid-sized hosting companies migrating all or 
part of their infrastructure off Linux/Xen to a proprietary solution, 
because of this very reason (problems with keeping dom0 kernel up to 
date, problems with deploying it on new machines etc.).

-- 
Tomasz Chmielewski
http://wpkg.org

