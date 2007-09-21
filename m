Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbXIUDId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbXIUDId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 23:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbXIUDI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 23:08:26 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:36266 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbXIUDI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 23:08:26 -0400
Date: Thu, 20 Sep 2007 21:08:24 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andreas Schwab <schwab@suse.de>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-serial@vger.kernel.org
Subject: Re: Don't cross the (tty) streams
Message-ID: <20070921030824.GD10625@parisc-linux.org>
References: <20070920210221.GC10625@parisc-linux.org> <jer6ktt490.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jer6ktt490.fsf@sykes.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 11:29:31PM +0200, Andreas Schwab wrote:
> Read the thread starting here:
> <http://lists.gnu.org/archive/html/bug-bash/2007-09/msg00020.html>.

Thanks, Andreas.  I tested it with /bin/echo instead of the built-in
echo and the problem disappeared.  Both machines were running
bash 3.1.17(1)-release.

"Not all bugs are kernel bugs" x10.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
