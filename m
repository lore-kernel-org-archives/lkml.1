Return-Path: <linux-kernel-owner+w=401wt.eu-S933135AbYDQRKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135AbYDQRKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 13:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760142AbYDQRKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 13:10:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:55413 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010AbYDQRKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 13:10:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=tDoQI/wQ2ISGEjgKnXKBVcW85/lrO3JXSrMxhTM//rZFpvahkP0ApL5rLciroOpM1EC6KfB3YSHvN+neBLu81FLkuiRtiWyYZKLUSbsRtzD3uhBsUpkBbYdYZsRE6tE/07TNfFXMH7JClaBh3hFhBM7VBnIPbvz7GZ+EwMY0ifE=
Date: Thu, 17 Apr 2008 13:10:33 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "eial@cs.bgu.ac.il" <eial@cs.bgu.ac.il>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: keyboard disconnects with kernel 2.6.24-r4
Message-ID: <20080417130904.ZZRA012@mailhub.coreip.homeip.net>
References: <20080408114639.GA6554@joi> <200804082119.m38LJrP2010738@indigo.cs.bgu.ac.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804082119.m38LJrP2010738@indigo.cs.bgu.ac.il>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 12:19:53AM +0300, eial@cs.bgu.ac.il wrote:
> ok, understood, still how can I revert from devices/virtual to class/input again?
> 

I doubt that chaged sysfs lauout causes your issue. When your keyboard
"disconnects" do you see its leds blinking?

-- 
Dmitry
