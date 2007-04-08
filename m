Return-Path: <linux-kernel-owner+w=401wt.eu-S966049AbXDHC4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966049AbXDHC4r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 22:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966043AbXDHC4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 22:56:47 -0400
Received: from thunk.org ([69.25.196.29]:59308 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933644AbXDHC4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 22:56:46 -0400
Date: Sat, 7 Apr 2007 22:56:32 -0400
From: Theodore Tso <tytso@mit.edu>
To: johnrobertbanks@fastmail.fm
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Ignatich <ignatich@gmail.com>,
       reiserfs-list@namesys.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Reiser4. BEST FILESYSTEM EVER.
Message-ID: <20070408025632.GA17646@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, johnrobertbanks@fastmail.fm,
	Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
	"H. Peter Anvin" <hpa@zytor.com>, Ignatich <ignatich@gmail.com>,
	reiserfs-list@namesys.com, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <46157B5B.5000602@gmail.com> <1175817921.18400.1183285196@webmail.messagingengine.com> <461592FB.5060507@zytor.com> <1175819681.20754.1183287946@webmail.messagingengine.com> <461596DE.2020802@zytor.com> <1175823288.25662.1183293506@webmail.messagingengine.com> <4615C780.5040407@zytor.com> <1175833931.8916.1183307802@webmail.messagingengine.com> <20070407191715.GG3510@csclub.uwaterloo.ca> <1175993097.32498.1183512070@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175993097.32498.1183512070@webmail.messagingengine.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 07, 2007 at 05:44:57PM -0700, johnrobertbanks@fastmail.fm wrote:
> To get a feel for the performance increases that can be achieved by
> using compression, we look at the total time (in seconds) to run the
> test:

You mean the performance increases of writing a file which is mostly
all zero's?  Yawn.....

					- Ted
