Return-Path: <linux-kernel-owner+w=401wt.eu-S1759209AbZLGJGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209AbZLGJGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 04:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757674AbZLGJGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 04:06:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40490 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982AbZLGJGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 04:06:31 -0500
Date: Mon, 7 Dec 2009 10:06:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [3/3] Fix unwind annotations for 64bit kernel
Message-ID: <20091207090634.GC18989@one.firstfloor.org>
References: <20091206313.812075626@firstfloor.org> <20091206141311.CE0A0B151F@basil.firstfloor.org> <4B1CC28F0200007800024075@vpn.id2.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1CC28F0200007800024075@vpn.id2.novell.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So do we, but the initial submission was rejected due to doing too many
> things at once. I didn't since find time (admittedly also because not
> giving it priority) to split the patch. Thanks for giving it another try!

I'm not sure what should be split, it's all related and straight forward.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
