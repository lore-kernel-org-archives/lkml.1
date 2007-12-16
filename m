Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbXLPFP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbXLPFP7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 00:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbXLPFPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 00:15:50 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:34252 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbXLPFPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 00:15:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:reply-to:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type;
        b=v3lzwIa40PlV/MVXQmlO6zuTbh8TwsYWdOefOLXCxiSqtkoWcG0ahf4URqE1Ryofg0ym8sQUuE/Dm10EvzKJVrRm1qjc2dpdN1JPYkrPTjcYBN9/eMf/kX/vMJxDRBAog0nGTiqNuWYVx7GLC5tK201LkMSjI1czBNruTmDdl+w=
Date: Sun, 16 Dec 2007 00:15:39 -0500 (EST)
From: Parag Warudkar <parag.warudkar@gmail.com>
X-X-Sender: parag@mini.warudkars.net
Reply-To: parag.warudkar@gmail.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
In-Reply-To: <Pine.LNX.4.64.0712151340060.3807@mini.warudkars.net>
Message-ID: <Pine.LNX.4.64.0712160015020.7320@mini.warudkars.net>
References: <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>
 <alpine.LFD.0.99999.0712101117300.11977@localhost.localdomain> 
 <82e4877d0712102049g4830a573n86b7f72f31a42f11@mail.gmail.com> 
 <200712141817.47581.lenb@kernel.org> <82e4877d0712141651j3965fd85ged2cefed5336e1ef@mail.gmail.com>
 <alpine.LFD.0.99999.0712150907180.6933@localhost.localdomain>
 <Pine.LNX.4.64.0712151340060.3807@mini.warudkars.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Dec 2007, Parag Warudkar wrote:

>> I will run it for a little longer just to be sure - but I don't think it 
>> will be a problem.

No problems for last 10 hours - I consider this fixed.

Parag
