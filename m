Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725AbYBDXOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbYBDXOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 18:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756731AbYBDXOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 18:14:00 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:51544 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765AbYBDXN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 18:13:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nTKooE8r/+xkv5Z4LQMs+zqTN4IbjVQMrBDg31QnKoWfyiGF8NpLC69Sqi223sZXE7OCnHGx5jpcBEWix36+en8tL9GGtFAaUVG8zPGY/3yBrCYPq+PPoj4OuB/k+vNkYJXnnEWd/f9juITcQxntFSLYn/PmIYRiYfoBxHXtV94=
Message-ID: <15577be70802041513p796172b2y2e17b7882763b02c@mail.gmail.com>
Date: Tue, 5 Feb 2008 00:13:57 +0100
From: "Abel Bernabeu" <abel.bernabeu@gmail.com>
To: linux-kernel@vger.kernel.org, "Jiri Kosina" <jkosina@suse.cz>,
       "Pavel Machek" <pavel@ucw.cz>
Subject: Re: Fwd: brk randomization breaks columns
In-Reply-To: <Pine.LNX.4.64.0802042346020.30873@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080204122837.GA1647@elf.ucw.cz> <20080204130156.GA8730@elte.hu>
	 <Pine.LNX.4.64.0802041528470.30955@jikos.suse.cz>
	 <Pine.LNX.4.64.0802041635000.30955@jikos.suse.cz>
	 <15577be70802041016m97cddbfk43b9073408bcbce9@mail.gmail.com>
	 <15577be70802041029o2975ba6do34589bbdc81d1652@mail.gmail.com>
	 <20080204195251.GB4915@elf.ucw.cz>
	 <15577be70802041354s23e5b289w56f724dfdf8c3242@mail.gmail.com>
	 <Pine.LNX.4.64.0802042346020.30873@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/2/4, Jiri Kosina <jkosina@suse.cz>:

> Abel, I actually don't think you have chance to have any issues with
> randomization, as the mentioned post talks about 2.6.22.10, which doesn't
> randomize the brk start at all.

You are rigth, my kernel just randomizes stack top.

I've got a bit sick with this crash in the latest days, trying to
understand the elf loader, trying toolchain configurations, etc... O:)

Yours, Abel.
