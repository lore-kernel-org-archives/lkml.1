Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbZAJQv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbZAJQv0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 11:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZAJQvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 11:51:14 -0500
Received: from lazybastard.de ([212.112.238.170]:57629 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbZAJQvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 11:51:14 -0500
Date: Sat, 10 Jan 2009 17:50:33 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Brown <lkml@davidb.org>, Phil Oester <kernel@linuxace.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
Message-ID: <20090110165033.GA23943@logfs.org>
References: <E1LKy3v-0003KO-Nx@dylan.lougher.demon.co.uk> <20090108165029.GA10951@infradead.org> <20090108175338.2abbee16.akpm@linux-foundation.org> <4966B24E.1050700@lougher.demon.co.uk> <ac3eb2510901081824g38abc47g4619e80ffaf8f1c5@mail.gmail.com> <20090109023629.GA29520@linuxace.com> <20090109165422.GF24884@logfs.org> <20090109193738.GA9827@linode.davidb.org> <20090109211937.GA14342@logfs.org> <20090110124335.GB30744@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090110124335.GB30744@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 January 2009 13:43:35 +0100, Ingo Molnar wrote:
> 
> What does a performance hit have to do with an ABI? Absolutely nothing - 
> if such a bug is noticed it is fixed, that's it. Your argument does not 
> parse and makes absolutely zero technical sense.
> 
> Your "ABI is forever" objection against a _read only_ filesystem is a 
> newbie mistake worthy of cookie file inclusion - i had a real good laugh 
> when i read it ;-)

Thank you, glad to be of service.  Should I have picked an example where
the code becomes horribly convoluted and there is nothing you can do
about it?

But since I am clearly the newbie, could you try to teach my stupid ass
instead of just ridiculing it?  What is the thing that makes a read only
filesystem special?  And why does everyone believe that I am arguing
against merging squashfs when I'm not?

Jörn

-- 
The only real mistake is the one from which we learn nothing.
-- John Powell
