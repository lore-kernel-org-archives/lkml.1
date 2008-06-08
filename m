Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbYFHOue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbYFHOue (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 10:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbYFHOuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 10:50:25 -0400
Received: from styx.suse.cz ([82.119.242.94]:60863 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753929AbYFHOuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 10:50:24 -0400
Subject: Re: Missing patch from stable [3/7]
From: Miklos Szeredi <mszeredi@suse.cz>
To: Willy Tarreau <w@1wt.eu>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
       Michael Halcrow <mhalcrow@us.ibm.com>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20080608122920.GA10491@1wt.eu>
References: <20080608085923.GC6439@1wt.eu> <1212923462.4020.224.camel@tucsk>
	 <20080608122920.GA10491@1wt.eu>
Content-Type: text/plain
Date: Sun, 08 Jun 2008 16:50:22 +0200
Message-Id: <1212936622.4020.236.camel@tucsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-08 at 14:29 +0200, Willy Tarreau wrote:

> Well, you know the implications of leaving these known bugs open more than
> me. If you think some of them are really not needed, I'm fine with this,
> but some definitely fix real bugs (judging by the code and the comments).

Yeah.  Perhaps there should also be a rule, that -stable patches for
EXPERIMENTAL stuff (like ecryptfs) are automatically rejected.  And then
they wouldn't increase the workload for the people collecting/reviewing
the stable series.

Thanks,
Miklos


