Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754Ab0AEQfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab0AEQfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 11:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126Ab0AEQfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 11:35:52 -0500
Received: from THUNK.ORG ([69.25.196.29]:47519 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741Ab0AEQfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 11:35:51 -0500
Date: Tue, 5 Jan 2010 11:35:36 -0500
From: tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Yin, Kangkai" <kangkai.yin@intel.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] jbd: jbd-debug and jbd2-debug should be writable.
Message-ID: <20100105163536.GC5457@thunk.org>
Mail-Followup-To: tytso@mit.edu, Jan Kara <jack@suse.cz>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Yin, Kangkai" <kangkai.yin@intel.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20091204031735.GN19635@kai-debian>
 <20091204094932.GC4272@skywalker.linux.vnet.ibm.com>
 <20091225204859.GG32757@thunk.org>
 <20100104222614.GB3252@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100104222614.GB3252@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 04, 2010 at 11:26:14PM +0100, Jan Kara wrote:
> On Fri 25-12-09 15:48:59, tytso@mit.edu wrote:
> > The ext4 portion has been added to the ext4 patch queue.
> > 
> > Jan, you want to add this to the ext3 tree?
>   Thanks for the notification. Actually, I've already sent the original
> patch to Linus and that was for both jbd and jbd2. The patch was so trivial
> I thought it's not worth splitting it up. I'm sorry if it caused any
> trouble to you.

No worries, I hadn't realized it had already been sent up to Linus.

   	      	     	      	     - Ted
