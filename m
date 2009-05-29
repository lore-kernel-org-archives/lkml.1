Return-Path: <linux-kernel-owner+w=401wt.eu-S1759553AbZE2ObK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553AbZE2ObK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 10:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756906AbZE2Oa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 10:30:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:59266 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758877AbZE2Oaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 10:30:55 -0400
Subject: Re: [PATCH 2/2 -tip] drm/i915: intel_lvds.c fix section mismatch
 warning
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>, Dave Airlie <airlied@linux.ie>,
       drm list <dri-devel@lists.sf.net>, Ingo Molnar <mingo@elte.hu>,
       Eric Anholt <eric@anholt.net>, mjg@redhat.com,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jarod Wilson <jarod@redhat.com>
In-Reply-To: <200905290934.14675.jarod@redhat.com>
References: <1242800768.3260.21.camel@localhost.localdomain>
	 <200905281100.21386.jarod@redhat.com>
	 <1243577795.3159.27.camel@localhost.localdomain>
	 <200905290934.14675.jarod@redhat.com>
Content-Type: text/plain
Date: Fri, 29 May 2009 19:58:36 +0530
Message-Id: <1243607316.3210.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Fri, 2009-05-29 at 09:34 -0400, Jarod Wilson wrote:
> On Friday 29 May 2009 02:16:35 Jaswinder Singh Rajput wrote:
> > I am not sure where this patch should go.
> > 
> > So I am also mailing to Andrew and Dave, it they find this useful then
> > they can add in their tree.
> 
> Dave is on vacation a bit longer, iirc. Not entirely sure where else
> this might go either. I'm sure *someone* will pick it up sooner or
> later... In any case, thanks for the fix for my flub.
> 
> Acked-by: Jarod Wilson <jarod@redhat.com>
> 

Can you accept this patch with Jarod Ack as Dave is on vacation and Ingo
is still busy with perfcounter ;-)

Thanks,
--
JSR

