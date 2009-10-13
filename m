Return-Path: <linux-kernel-owner+w=401wt.eu-S933674AbZJMOon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933674AbZJMOon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933425AbZJMOom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:44:42 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:35253 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760056AbZJMOoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:44:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QHdmoGJ3Ts2bGXBmAjXdzb1DiQUrFb2BqROOWUq/J+CsjUdh/1AAjdwR1NmqILNBwz
         NjbiWLGh0TUYmhYoQ9cDYPed5iZyB4E45PrQ3UYG80pdU67A/l4PaVqcGI+XGQsckp4Y
         okVJbnKA/qJCuyk9YOZE5s3VSZN9l3lNqb92U=
Date: Tue, 13 Oct 2009 18:43:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>, x86team <x86@kernel.org>
Subject: Re: [RFC -tip] apic NOOP driver
Message-ID: <20091013144356.GD6019@lenovo>
References: <20090924203147.GD5476@lenovo> <20091013103229.GB3915@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013103229.GB3915@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Tue, Oct 13, 2009 at 12:32:29PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > Ingo,
| > 
| > here is what implemented at moment. Did you mean something like that? 
| > Note that it's quite early RFC not for any kind of inclusion.
| 
| yeah, this looks pretty good.
| 
| And i'd suggest to separate the patches that introduce this APIC driver 
| from the changes that make use of it. Makes for an easier bisection 
| target.
| 
| 	Ingo
| 

OK, will do so over fresh -tip.

	-- Cyrill
