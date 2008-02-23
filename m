Return-Path: <linux-kernel-owner+w=401wt.eu-S1762024AbYBWTqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762024AbYBWTqV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 14:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756419AbYBWTqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 14:46:13 -0500
Received: from testure.choralone.org ([194.9.77.134]:41586 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507AbYBWTqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 14:46:12 -0500
Date: Sat, 23 Feb 2008 14:45:31 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Gabriel C <crazy@frugalware.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gabriel C <nix.or.die@googlemail.com>, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>, Greg KH <greg@kroah.com>
Subject: Re: modular intel-agp does not work on my box
Message-ID: <20080223194531.GA929@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Gabriel C <crazy@frugalware.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Gabriel C <nix.or.die@googlemail.com>,
	Dave Airlie <airlied@linux.ie>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Doug Thompson <dougthompson@xmission.com>, Greg KH <greg@kroah.com>
References: <47BE222B.2080500@googlemail.com> <alpine.DEB.0.82.0802220205410.3412@skynet.skynet.ie> <47BE32C7.5060008@googlemail.com> <47BE4125.3080503@googlemail.com> <20080222041921.GD21061@codemonkey.org.uk> <20080223000355.42219a89.akpm@linux-foundation.org> <20080223181414.GA24313@codemonkey.org.uk> <47C07457.1060606@frugalware.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C07457.1060606@frugalware.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 08:30:31PM +0100, Gabriel C wrote:

 > What does happen if one builds both into the kernel ? ( eg: all the *_AGP* Y , and all the *_EDAC* y ) 
 > 
 > Guessing no one of them will work ?

First one to init wins.

	Dave

-- 
http://www.codemonkey.org.uk
