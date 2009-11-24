Return-Path: <linux-kernel-owner+w=401wt.eu-S1757728AbZKXBOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728AbZKXBOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 20:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757720AbZKXBOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 20:14:30 -0500
Received: from cust-66-114-178-157.t6broadband.com ([66.114.178.157]:49746
	"HELO bcdb.mspradling.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with SMTP id S1757716AbZKXBO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 20:14:29 -0500
Date: Mon, 23 Nov 2009 20:12:02 -0500
From: Michael Spradling <mike@mspradling.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: mike@mspradling.com, davem@davemloft.net, hugh.dickins@ticali.co.uk,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixed bug in Wireless Extension Code
 (CONFIG_WEXT_CORE).
Message-ID: <20091124011202.GC26103@MSServer>
Reply-To: mike@mspradling.com
References: <1258936602-6110-1-git-send-email-mike@mspradling.com>
 <1258969541.7094.138.camel@johannes.local>
 <20091123154225.GA26103@MSServer>
 <1258991626.7094.174.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258991626.7094.174.camel@johannes.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I lost my config file and haven't been able to reproduce it.
If I come across this again I will email you directly.

--
Mike Spradling

On Mon, Nov 23, 2009 at 04:53:46PM +0100, Johannes Berg wrote:
> On Mon, 2009-11-23 at 10:42 -0500, Michael Spradling wrote:
> > I don't think its a Kconfig issue, see notes below.  However,
> > I have included my config file just in case I may be wrong.
> 
> You config file doesn't have _any_ wireless options set. Not even
> CONFIG_NET.
> 
> johannes



