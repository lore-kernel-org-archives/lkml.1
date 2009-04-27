Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbZD0WLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbZD0WLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 18:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbZD0WLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 18:11:47 -0400
Received: from sous-sol.org ([216.99.217.87]:45674 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753339AbZD0WLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 18:11:46 -0400
Date: Mon, 27 Apr 2009 15:11:21 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Chris Frey <cdfrey@foursquare.net>
Cc: chrisw@sous-sol.org, linux-kernel@vger.kernel.org, jlayton@redhat.com
Subject: Re: fs/cifs/connect.c fix missing in latest stable
Message-ID: <20090427221121.GD3036@sequoia.sous-sol.org>
References: <20090427205742.GA888@foursquare.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090427205742.GA888@foursquare.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Frey (cdfrey@foursquare.net) wrote:
> Hi Chris,
> 
> The latest stable release 2.6.29.2 appears to be missing Jeff Layton's
> fix in commit f083def68f84b04fe3f97312498911afce79609e (in Linus's tree).
> 
> I'm not the expert... I just noticed that this was mentioned on
> full-disclosure: http://marc.info/?l=full-disclosure&m=123936563230145&w=2
> (near the end of Andreas's post)

Yes, I think cifs developers are still doing cleanups in that area.
Jeff?

thanks,
-chris
