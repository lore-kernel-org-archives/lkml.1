Return-Path: <linux-kernel-owner+w=401wt.eu-S932359AbZLNR5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbZLNR5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 12:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932349AbZLNR5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 12:57:15 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34965 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932345AbZLNR5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 12:57:14 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5832"; a="29880180"
Subject: Re: GPIO support for HTC Dream
From: Daniel Walker <dwalker@codeaurora.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arve Hj?nnev?g <arve@android.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Iliyan Malchev <malchev@google.com>
In-Reply-To: <20091213212918.GE5114@elf.ucw.cz>
References: <20091208102842.GH12264@elf.ucw.cz>
	 <20091208224550.GA26915@n2100.arm.linux.org.uk>
	 <d6200be20912081639mdd853bg4080f415116d018c@mail.gmail.com>
	 <20091209113739.GC22752@elf.ucw.cz> <1260375495.23633.175.camel@desktop>
	 <20091213212918.GE5114@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 09:40:55 -0800
Message-ID: <1260812455.13078.3.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-13 at 22:29 +0100, Pavel Machek wrote:

> > I'm going to end up pulling a lot of these git commit into my git tree.
> > It would be pretty easy for me to just pull this GPIO change directly ..
> > I assume you haven't found a way to work with git that suites you? It
> > would be best if you used git, but I could try to do some sort of quilt
> > export if that works better for you.
> 
> I can easily "pull" git trees. I do my own work in git, but usually
> not in a way that would be useful for pushing upstream (see my trees
> at git.kernel.org). 
> 
> I *could* add my dream trees to those that are mirrored at kernel.org,
> when things settle a bit. (Should I?)

I'm not sure I know what you mean .. What benefit would that have?

> But I'd really prefer to push my stuff using plain old patches in
> emails.

What I was meaning is you need to keep track of my tree via git, just so
you know what's going into it and can work off it. If your already doing
that, then no problem ..

Daniel

