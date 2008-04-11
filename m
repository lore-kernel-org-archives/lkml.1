Return-Path: <linux-kernel-owner+w=401wt.eu-S1759810AbYDKLtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759810AbYDKLtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 07:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759712AbYDKLsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 07:48:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:33905 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760617AbYDKLsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 07:48:45 -0400
Date: Fri, 11 Apr 2008 13:49:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: matthltc@us.ibm.com
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Cedric Le Goater <clg@fr.ibm.com>, linux-pm@lists.linux-foundation.org
Subject: Re: [RFC PATCH 1/4] Container Freezer: Add TIF_FREEZE flag to all
	architectures
Message-ID: <20080411114930.GB1740@elf.ucw.cz>
References: <20080403210316.397506379@us.ibm.com> <20080403210316.659937801@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080403210316.659937801@us.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-04-03 14:03:17, matthltc@us.ibm.com wrote:
> This patch is the first step in making the refrigerator() available 
> to all architectures, even for those without power management. 
> 
> The purpose of such a change is to be able to use the refrigerator() 
> in a new control group subsystem which will implement a control group
> freezer.
> 
> Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
> Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
> Tested-by: Matt Helsley <matthltc@us.ibm.com>
> Cc: linux-pm@lists.linux-foundation.org

ACK.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
