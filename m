Return-Path: <linux-kernel-owner+w=401wt.eu-S1760916AbYDZScT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916AbYDZScT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 14:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757634AbYDZScI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 14:32:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41039 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340AbYDZScH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 14:32:07 -0400
Date: Sat, 26 Apr 2008 20:38:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: mainline boot failures I: qemu
Message-ID: <20080426183804.GD17905@one.firstfloor.org>
References: <20080426140210.GA13365@basil.nowhere.org> <481343ED.1060002@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481343ED.1060002@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm experiencing a boot failure with current mainline and QEMU, too.
> The last commit is same as yours (b1721d0da266b4), but the boot log
> is different:

That's the same one I get now on different systems after I remove
the local broken patch that caused the other failure (sorry, didn't catch
that earlier) 

-Andi
