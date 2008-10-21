Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbYJUAcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbYJUAcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 20:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYJUAcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 20:32:35 -0400
Received: from anchor-post-33.mail.demon.net ([194.217.242.91]:4953 "EHLO
	anchor-post-33.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751287AbYJUAce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 20:32:34 -0400
Message-ID: <48FD232B.10508@lougher.demon.co.uk>
Date: Tue, 21 Oct 2008 01:32:43 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Re: Subject: [PATCH 01/16] Squashfs: inode operations
References: <E1KqrTW-0001xC-9M@dylan> <20081017165300.GA8076@logfs.org>
In-Reply-To: <20081017165300.GA8076@logfs.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> None of the comments below are a reason against mainline inclusion, imo.
> They should get handled, but whether that happens before or after a
> merge doesn't really matter.

Yeah you're right regarding your comments.  That's where code-review 
comes in handy, to spot things you don't see because you're too used to 
the code.

I'm working on a re-spin incorporating your comments, and it should be 
ready tomorrow.

Thanks for the code-review.

Phillip
