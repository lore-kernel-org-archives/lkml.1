Return-Path: <linux-kernel-owner+w=401wt.eu-S935521AbXHHAEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935521AbXHHAEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 20:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756708AbXHHAEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 20:04:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50451 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884AbXHHAEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 20:04:36 -0400
Date: Wed, 8 Aug 2007 02:04:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: dragoran <drago01@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: allow non root users to set io priority "idle" ?
Message-ID: <20070808000434.GA7353@one.firstfloor.org>
References: <46B6EDCB.6030806@gmail.com> <p73zm14lxyy.fsf@bingen.suse.de> <46B6F75D.1070808@gmail.com> <20070806103553.GA16133@one.firstfloor.org> <20070807204449.GA5245@kernel.dk> <f6ca9fed0708071435h31531279gb6ea0fc760be98df@mail.gmail.com> <f6ca9fed0708071518m159e0ef8vc2d8482913afbea6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6ca9fed0708071518m159e0ef8vc2d8482913afbea6@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 12:18:12AM +0200, dragoran wrote:
> so there is no real reason not to allow it for non root users?
> removing the check is easy (3 lines) ....
> or are there any other issues/problems?

Jens was only talking about the seek issue I mentioned I believe;
not about the PI problem.

-Andi
