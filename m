Return-Path: <linux-kernel-owner+w=401wt.eu-S1753623AbXJVSHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbXJVSHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbXJVSHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:07:41 -0400
Received: from main.gmane.org ([80.91.229.2]:52026 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbXJVSHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:07:40 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Parag Warudkar <parag.warudkar@gmail.com>
Subject: Re: 2.6.23 - MacMini - snd-hda-intel stopped working
Date: Mon, 22 Oct 2007 18:07:29 +0000 (UTC)
Message-ID: <loom.20071022T180112-37@post.gmane.org>
References: <82e4877d0710212008m335c5f15s88963aaebf2f6d4a@mail.gmail.com> <20071022100629.GA11114@dose.home.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 76.112.242.207 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.8) Gecko/20071008 Firefox/2.0.0.8)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tino Keitel <tino.keitel <at> gmx.de> writes:


> Not that this would help you a lot, but it worked with a stock 2.6.23 kernel
> here:
> 

Right. As was pointed in previous email the bug was introduced in post 2.6.23
updates (I was running git but Makefile version was still 2.6.23). 

Looks like we have a fix that'll go to Linus shortly. I'll go back to released
2.6.23.1 for the time being.

> 
> What model do you have? Mine is the first dual core version (1,66 GHz,
> Superdrive)

Same model I have, BTW.

Thanks

Parag

