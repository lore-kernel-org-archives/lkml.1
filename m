Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbXFLF2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbXFLF2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 01:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbXFLF1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 01:27:51 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:12495 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbXFLF1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 01:27:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=mBGiEs27aEf+PAUl9DT3ckFIKndspF1YnEExI/J9O7BYydp5QaKpyNjELUzY4/4hhM5vUdzvp9qNyJhLZASAkLAq05nvcUZAHuRVrJFKMr56hYorgsbrQn/6JMtKJbl+O2CLt+IV/HobKtcU9xcCTltKwO29zE+5tsPLpRQQ8v4=
Date: Tue, 12 Jun 2007 09:26:18 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eric Sandeen <sandeen@sandeen.net>,
       Cyrill Gorcunov <gorcunov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix possible leakage of blocks in UDF (try 2)
Message-ID: <20070612052618.GA6522@cvg>
References: <20070611104911.GH567@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611104911.GH567@duck.suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Jan Kara - Mon, Jun 11, 2007 at 12:49:11PM +0200]
|   Hi Andrew,
| 
|   attached is a new version of the patch fixing possible leakage of
[SNIP]

Thanks, Jan

		Cyrill

