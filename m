Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbYJPTtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbYJPTtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYJPTtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:49:09 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:53348 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbYJPTtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:49:08 -0400
Date: Thu, 16 Oct 2008 21:49:02 +0200
From: Arjan Opmeer <arjan@opmeer.net>
To: trelane@digitasaru.net, linux-kernel@vger.kernel.org
Message-ID: <20081016194902.GA5109@adopmeer.homeip.net>
References: <20081016192517.GA7631@digitasaru.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016192517.GA7631@digitasaru.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: Re: elantech driver status
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joseph,

On Thu, Oct 16, 2008 at 02:25:18PM -0500, Joseph Pingenot wrote:
> I was wondering what the status of the elantech touchpad driver is.
> Particularly, when we can expect it'll be incorporated into the main tree.

Just today Dmitry Torokhov, the Linux input system maintainer, mailed me
about how he was looking into that. To quote: 

  "I am attaching the version of Elantech driver that I want to apply (there
   were some tiny changes)..."

where applying means adding it to his input system source tree ready to be
sent on to Linus. So despair not, things are still moving forward! :)

>   What's keeping it from being in 2.6.28?

Now that the driver is cleaned up, not much anymore :)


Arjan

