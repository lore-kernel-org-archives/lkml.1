Return-Path: <linux-kernel-owner+w=401wt.eu-S1762943AbZBZOcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762943AbZBZOcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758112AbZBZOTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:19:52 -0500
Received: from thunk.org ([69.25.196.29]:39775 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758097AbZBZOTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:19:50 -0500
Date: Thu, 26 Feb 2009 09:19:46 -0500
From: Theodore Tso <tytso@mit.edu>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Crash in 2.6.28.7 - ext4 related
Message-ID: <20090226141946.GE7227@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Fabio Comolli <fabio.comolli@gmail.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <b637ec0b0902251203i1fe5f081vfd06350dbf5060e9@mail.gmail.com> <b637ec0b0902260118o19f74acal567440a6f049512@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b637ec0b0902260118o19f74acal567440a6f049512@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 10:18:29AM +0100, Fabio Comolli wrote:
> OK, I see that my message didn't reach neither linux-kernel nor
> linux-fsdevel, maybe because of the image size (484K).
> 
> If anyone is interested in details, please let me know.

Yes, we're interested.  I've changed the cc list to be the linux-ext4
list, though.  That's a better list for tracking such things than the
more general linux-fsdevel list.

Can you post the image (I assume of the kernel oops message, I hope)
somewhere?  If you cc'ed directly on your first e-mail posting, it
apparently never arrived to my inbox, either....

       		   	      	    	       - Ted

