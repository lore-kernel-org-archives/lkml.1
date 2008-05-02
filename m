Return-Path: <linux-kernel-owner+w=401wt.eu-S965080AbYEBUjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965080AbYEBUjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 16:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932770AbYEBUi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 16:38:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:27343 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764381AbYEBUi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 16:38:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ucgs6mhtbO6ckyaMmNZ68WKgHccP8BvuH1UgCD0lJ7vyLH1cZuiYcU3tp+e2qf6g3CkuAXw87eXOjukI8acY1QIXLgIMKDDfwqfAtSO9FrpRlpQf/rt3wcAN7Gab0hURqxz9aSFg3t6QvvG4Naj0NQlhzEeuOwhW5dpwRCXn514=
Message-ID: <3d8471ca0805021338x7cde7d1fwbbb58a6c65a1349d@mail.gmail.com>
Date: Fri, 2 May 2008 22:38:53 +0200
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: 'global' rq->clock (was Re: Horrendous Audio Stutter - current git)
Cc: "Mike Galbraith" <efault@gmx.de>, "Frans Pop" <elendil@planet.nl>,
       "Parag Warudkar" <parag.warudkar@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <1209758186.6929.18.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com>
	 <1209740523.4776.1.camel@marge.simson.net>
	 <200805021749.10205.elendil@planet.nl>
	 <200805022053.24779.elendil@planet.nl>
	 <1209756423.4693.8.camel@marge.simson.net>
	 <1209758186.6929.18.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2008 at 9:56 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>  Let me try and come up with something slightly less horrible

Does this obsolete Ingo's "sched: make cpu_clock() globally synchronous"?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=27ec4407790d075c325e1f4da0a19c56953cce23

My laptop is UP, so I cannot test this :-(

-- 
Guillaume
