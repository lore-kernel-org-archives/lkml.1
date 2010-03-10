Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab0CJGWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 01:22:37 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:38767 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab0CJGWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 01:22:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cJu3g1aVHX0G9OBgWBsf1JGuXI0wug10IRKYJI3/cbct4D1Veb4r7qJmjJ+pJTqmQz
         ntZaWuCb2wSENMb5aa1P7+ZFAz+H4/ODnfFnZFa/+oy6vGKIxiS+Wd27HRuAjX8BLEaM
         VKd2LNdsGo0c+EGBh11BMaMX7q8rfYgLvt8rA=
Date: Tue, 9 Mar 2010 22:22:27 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Vadim Zaliva <lord@crocodile.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] integer overflow issue in 'appletouch' driver
Message-ID: <20100310062227.GB2445@core.coreip.homeip.net>
References: <E64899AA-23A5-49D7-8C91-B94A095290E0@crocodile.org>
 <1268034117.3819.1.camel@jlt3.sipsolutions.net>
 <36779F26-DB1B-46ED-8635-01B03E559B55@crocodile.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36779F26-DB1B-46ED-8635-01B03E559B55@crocodile.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 11:43:25AM -0800, Vadim Zaliva wrote:
> On Mar 7, 2010, at 23:41 , Johannes Berg wrote:
> 
> > Hmm, you're probably right, and I cannot test with my powerbook as I'm
> > about to leave on travel and it's at my parents.
> 
> Any other maintainers I should forward it to? Looks like straightforward small bug.
> 

Just need your Signed-off-by please.

-- 
Dmitry
