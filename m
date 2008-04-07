Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbYDGJxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbYDGJxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 05:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbYDGJx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 05:53:26 -0400
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:36256 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886AbYDGJxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 05:53:25 -0400
Message-ID: <47F9EEB8.3020109@panasas.com>
Date: Mon, 07 Apr 2008 12:51:52 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Benny Halevy <bhalevy@panasas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>, apw@shadowen.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] checkpatch: relax spacing and line length
References: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr>	 <20080405221822.376f0018.akpm@linux-foundation.org>	 <47F8B98A.1020704@panasas.com> <1207507971.1803.40.camel@localhost>
In-Reply-To: <1207507971.1803.40.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06 2008 at 21:52 +0300, Joe Perches <joe@perches.com> wrote:
> On Sun, 2008-04-06 at 14:52 +0300, Benny Halevy wrote:
>> The idea is [] to allow for a bit more flexibility to
>>  accommodate for a more robust indentation style.
> 
> Isn't this an editor/tools issue more than a checkpatch one?
> 
> I think you should first try to get the most frequently used
> code editors and pretty printers (vim/emacs/eclipse/indent, etc)
> to support the tabs to level, spaces to align style.
> 
> g'luck with that.
> 
> --

I have one such editor to date, Me. But I can not use it's output
because checkpatch.pl forbids it, and I get scorned by my maintainers.
So I think you got it reversed. First allow it then automate for it
other wise there is no use, right?

Boaz
