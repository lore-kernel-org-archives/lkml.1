Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab0CFVAt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 16:00:49 -0500
Received: from wolff.to ([65.117.131.163]:55582 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754499Ab0CFVAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 16:00:47 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Mar 2010 16:00:46 EST
Date: Sat, 6 Mar 2010 14:53:41 -0600
From: Bruno Wolff III <bruno@wolff.to>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL V2] Squashfs updates for 2.6.34-rc1
Message-ID: <20100306205341.GA28316@wolff.to>
References: <4B91317D.7000205@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B91317D.7000205@lougher.demon.co.uk>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 16:29:49 +0000,
  Phillip Lougher <phillip@lougher.demon.co.uk> wrote:
> Hi Linus,
> 
> Please consider pulling the following revised Squashfs update for 2.6.34-rc1.
> I have removed all the lzma/bunzip2/inflate/lzo code changes (which as far as I
> know were the blocking issue previously).
> 
> What remains in the pull request is a clean-up/refactoring of the zlib
> wrapper code, outline knowledge of lzma/lzo compressed filesystems (unsupported,
> but it gives users an understandable error message when they try to mount them),
> and some trivial code tidying.

I saw that Linus pulled this and some earlier related packages. I am not sure
if I should expect working lzma squashfs in 2.6.34 right now, or if I still
need to wait a bit?

P.S.
Thanks for working on this!
