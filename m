Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbZBEVVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbZBEVVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 16:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbZBEVVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 16:21:06 -0500
Received: from relay.2ka.mipt.ru ([194.85.80.65]:44515 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbZBEVVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 16:21:05 -0500
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Feb 2009 16:21:04 EST
Date: Fri, 6 Feb 2009 00:14:03 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@openedhand.com>,
       Matt Reimer <mreimer@vpop.net>
Subject: Re: [PATCH 0/6] fix PASIC3/DS1WM, use MFD core
Message-ID: <20090205211403.GA25458@2ka.mipt.ru>
References: <1233852820-28549-1-git-send-email-philipp.zabel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233852820-28549-1-git-send-email-philipp.zabel@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp.

On Thu, Feb 05, 2009 at 05:53:34PM +0100, Philipp Zabel (philipp.zabel@gmail.com) wrote:
> the following patches turn DS1WM into an MFD cell driver, make PASIC3 use 
> the MFD core functions to register it and remove the generic clock API
> code from DS1WM as MFDs currently can't register their clocks with it.
> With those applied, 1-Wire is finally in a working state on magician.

Looks good. Feel free to add my ack if needed.
Drop a mail if you want to me to push it upstream separately from the
core part it depends on.

-- 
	Evgeniy Polyakov
