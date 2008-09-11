Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbYIKNjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbYIKNjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 09:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbYIKNjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 09:39:39 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:50370 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167AbYIKNji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 09:39:38 -0400
Date: Thu, 11 Sep 2008 09:38:47 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Faidon Liambotis <paravoid@debian.org>, David Miller <davem@davemloft.net>,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
Message-ID: <20080911133847.GD5082@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jeff Mahoney <jeffm@suse.com>,
	Faidon Liambotis <paravoid@debian.org>,
	David Miller <davem@davemloft.net>, dwmw2@infradead.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	torvalds@linux-foundation.org
References: <48C68507.6000609@suse.com> <1221087719.13621.50.camel@macbook.infradead.org> <20080910.160505.14060698.davem@davemloft.net> <48C8BC17.5050508@debian.org> <48C8C580.5020803@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C8C580.5020803@suse.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 03:15:12AM -0400, Jeff Mahoney wrote:
> 
> In the end, though, Andrew's right. We can't go breaking udev prior to
> 127 with this.

But it's OK to break various distribution's kernel packaging tools?

    	       	     	     		    	   	     - Ted
