Return-Path: <linux-kernel-owner+w=401wt.eu-S935516AbXHHFG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935516AbXHHFG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 01:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbXHHFGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 01:06:20 -0400
Received: from brick.kernel.dk ([87.55.233.238]:4141 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096AbXHHFGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 01:06:19 -0400
Date: Wed, 8 Aug 2007 07:06:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: dragoran <drago01@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: allow non root users to set io priority "idle" ?
Message-ID: <20070808050617.GE5245@kernel.dk>
References: <46B6EDCB.6030806@gmail.com> <p73zm14lxyy.fsf@bingen.suse.de> <46B6F75D.1070808@gmail.com> <20070806103553.GA16133@one.firstfloor.org> <20070807204449.GA5245@kernel.dk> <f6ca9fed0708071435h31531279gb6ea0fc760be98df@mail.gmail.com> <f6ca9fed0708071518m159e0ef8vc2d8482913afbea6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6ca9fed0708071518m159e0ef8vc2d8482913afbea6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08 2007, dragoran wrote:
> so there is no real reason not to allow it for non root users?
> removing the check is easy (3 lines) ....
> or are there any other issues/problems?

Andi already explained to you why it can't be enabled for non-root
users. I merely talked about why idle priority works.

-- 
Jens Axboe

