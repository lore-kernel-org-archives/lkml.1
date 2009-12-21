Return-Path: <linux-kernel-owner+w=401wt.eu-S1751940AbZLUX6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbZLUX6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 18:58:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbZLUX6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 18:58:01 -0500
Received: from wolff.to ([65.117.131.163]:55739 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751653AbZLUX6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 18:58:00 -0500
Date: Mon, 21 Dec 2009 17:56:04 -0600
From: Bruno Wolff III <bruno@wolff.to>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       phillip.lougher@gmail.com, tim.bird@am.sony.com
Subject: Re: [PATCH 0/9] Squashfs: Add support for LZMA compressed filesystems
Message-ID: <20091221235604.GA20459@wolff.to>
References: <E1NHZ6K-00029J-Sw@dylan.lougher.demon.co.uk>
 <20091221231645.GA32141@wolff.to>
 <4B300912.5060905@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B300912.5060905@lougher.demon.co.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 23:47:30 +0000,
  Phillip Lougher <phillip@lougher.demon.co.uk> wrote:
> Bruno Wolff III wrote:
> >On Mon, Dec 07, 2009 at 08:37:48 +0000,
> >  Phillip Lougher <phillip@lougher.demon.co.uk> wrote:
> >>Hi,
> >>
> >>The following patches add LZMA decompression support to Squashfs, using the
> >>in-kernel LZMA decompression library.
> >
> >Do these still have a chance to make 2.6.33?
> >
> 
> It's very unlikely.  Andrew wanted it to spend a cycle in linux-next.  I'll then
> try for 2.6.34 merge.  I'm happy with that.

I hadn't seen it show up there yet either. But maybe its a bit too early
for that. If it gets there I might have a chance of convincing one of
the Fedora kernel guys of back porting it, since F13 is likely to be released
with the 2,6,34 kernel in any case. (Along with some actual numbers for
our live iso images to show it's important to have. But I can get those
using the devel version of squashfs without the kernel changes.)
I'll keep an eye out for it showing up in linux-next. Thanks for the update.
