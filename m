Return-Path: <linux-kernel-owner+w=401wt.eu-S1752505AbXCHQh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbXCHQh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbXCHQh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:37:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505AbXCHQh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:37:57 -0500
Date: Thu, 8 Mar 2007 11:37:16 -0500
From: Dave Jones <davej@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc3-mm1
Message-ID: <20070308163716.GA11031@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070307201839.6f45735b.akpm@linux-foundation.org> <20070308145043.GB5323@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308145043.GB5323@tuxdriver.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 09:50:43AM -0500, John W. Linville wrote:
 > On Wed, Mar 07, 2007 at 08:18:39PM -0800, Andrew Morton wrote:
 > 	    By removing NET_RADIO, these changes pave the way to making wireless
 > 	    extensions optional when cfg80211 can fully take over for some drivers
 > 	    and you don't have any older drivers that still require wext.
 > 
 > Honestly, I'm tempted to add the pre-802.11 stuff to the features
 > removal list.  I wonder if any of it still actually works...

FWIW, I've built these drivers in Fedora for aeons, and never had a single
bug filed against them. Either they're perfect, or no-one has that junk
any more.  I should turn them off for a build and see if anyone complains :)

	Dave

-- 
http://www.codemonkey.org.uk
