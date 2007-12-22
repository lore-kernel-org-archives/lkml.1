Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbXLVCk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbXLVCk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 21:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbXLVCkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 21:40:51 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55365 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbXLVCkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 21:40:51 -0500
Date: Sat, 22 Dec 2007 03:41:45 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, devzero@web.de,
       linux-kernel@vger.kernel.org, Matt.Domsch@dell.com
Subject: Re: [PATCH] [RFC] be more verbose when probing EDD
Message-ID: <20071222024145.GA6062@one.firstfloor.org>
References: <49015158@web.de> <47656B9E.3040405@zytor.com> <p73sl1vedhw.fsf@bingen.suse.de> <476C6D06.2070301@zytor.com> <20071222015758.GC4477@one.firstfloor.org> <476C74F1.2070407@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476C74F1.2070407@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2007 at 06:22:41PM -0800, H. Peter Anvin wrote:
> >Ok, that's a different argument than before. Ok. Although it's
> >only a few bytes. 
> >
> >I would lobby for any message at least contain the suggestion to try
> >edd=off. That could save users a lot of time.
> 
> The important thing is that there is a message before and after.  The 
> rest can be dealt with by Google on in documentation.  That's what the 

That means every user needs to waste at least 5 minutes to google/read
docs and be annoyed by someone's ads. Collective waste.

Just adding "Try edd=off if this hangs"  is ~23 bytes  and adding
that should be hardly a problem even in your 32k. Or perhaps if you're more
worried about code size than grammer "edd=off when hang" @)

-Andi


