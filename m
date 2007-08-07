Return-Path: <linux-kernel-owner+w=401wt.eu-S936713AbXHGWTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936713AbXHGWTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934431AbXHGWSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:18:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:48795 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935604AbXHGWSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:18:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qXBn15DbJdQJ7T7+MCyCMjuxqTK0NLWkNjbWVjWnDieT18CU6OE52p2GBBgu2ivIfYQIY5tS688YZtqvGNjZqMFGmJ36wWW+J9WLdyx9H1D+EuBRJ8QDjuksw5ZFexE25wFJyuNigAefUXqNC9Equ8LxHVE39TvJN9IQgAedIRQ=
Message-ID: <f6ca9fed0708071518m159e0ef8vc2d8482913afbea6@mail.gmail.com>
Date: Wed, 8 Aug 2007 00:18:12 +0200
From: dragoran <drago01@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: allow non root users to set io priority "idle" ?
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
In-Reply-To: <f6ca9fed0708071435h31531279gb6ea0fc760be98df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46B6EDCB.6030806@gmail.com> <p73zm14lxyy.fsf@bingen.suse.de>
	 <46B6F75D.1070808@gmail.com>
	 <20070806103553.GA16133@one.firstfloor.org>
	 <20070807204449.GA5245@kernel.dk>
	 <f6ca9fed0708071435h31531279gb6ea0fc760be98df@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

so there is no real reason not to allow it for non root users?
removing the check is easy (3 lines) ....
or are there any other issues/problems?

(resend sorry for the top post stupid gmail ;) )
