Return-Path: <linux-kernel-owner+w=401wt.eu-S1750968AbXCUEht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750968AbXCUEht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 00:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbXCUEht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 00:37:49 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:37004 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbXCUEht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 00:37:49 -0400
X-Greylist: delayed 2031 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Mar 2007 00:37:48 EDT
Date: Wed, 21 Mar 2007 00:03:42 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Nicolas Boichat <nicolas@boichat.ch>
Cc: linux-kernel@vger.kernel.org, mactel-linux-devel@lists.sourceforge.net
Subject: Re: [RFC][PATCH] Apple SMC driver (hardware monitoring and control)
Message-ID: <20070321040341.GA7409@hash.localnet>
References: <45F7C083.7090504@boichat.ch> <b6c5339f0703191443l5f8c5271pf43ea62e0c79a614@mail.gmail.com> <45FF86F6.7050200@boichat.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FF86F6.7050200@boichat.ch>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 03:02:14PM +0800, Nicolas Boichat wrote:
> I tried neverball on my Macbook Pro 1st generation (Core Duo, not Core 2
> Duo), and the x axis in inverted, not the y axis.
> 
> Could you confirm which axis is inverted on your Macbook?
> 
> Also, have you tried the modified hdaps-gl, available here:
> http://mactel-linux.svn.sourceforge.net/viewvc/mactel-linux/trunk/tools/hdaps-gl/
> ? Is it working correctly?

Ok I tried it out again and it is in fact the x-axis that is inverted
within neverball.  The hdaps-gl works fine (Macbook Core Duo here).  

Thanks for the driver!

-- 
Bob Copeland %% www.bobcopeland.com 

