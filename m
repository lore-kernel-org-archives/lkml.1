Return-Path: <linux-kernel-owner+w=401wt.eu-S966284AbXILK7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966284AbXILK7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 06:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764194AbXILK7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 06:59:22 -0400
Received: from mailhub.linpro.no ([213.236.139.167]:53830 "EHLO
	mailhub.linpro.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764180AbXILK7V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 06:59:21 -0400
From: =?iso-8859-1?Q?Dag-Erling_Sm=F8rgrav?= <des@linpro.no>
To: Arne Georg Gleditsch <argggh@dolphinics.no>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC+PATCH] RTC calibration
References: <ujrmyvt2tyy.fsf@false.linpro.no>
	<kjmsl5krwdk.fsf@pelargir.dolphinics.no>
Date: Wed, 12 Sep 2007 12:59:17 +0200
In-Reply-To: <kjmsl5krwdk.fsf@pelargir.dolphinics.no> (Arne Georg Gleditsch's
	message of "Wed, 12 Sep 2007 12:49:59 +0200")
Message-ID: <ujrk5qw175m.fsf@false.linpro.no>
User-Agent: Gnus/5.110004 (No Gnus v0.4) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arne Georg Gleditsch <argggh@dolphinics.no> writes:
> Dag-Erling Smørgrav <des@linpro.no> writes:
> > +	case RTC_SPEED_UP:
> > +		err = rtc_speed_up(rtc);
> > +		break;
> > +
> > +	case RTC_SLOW_DOWN:
> > +		err = rtc_speed_up(rtc);
> > +		break;
> This doesn't look quite right.  rtc_slow_down, surely?

Uh, yes.  ENOCOFFEE.

DES
-- 
Dag-Erling Smørgrav
Senior Software Developer
Linpro AS - www.linpro.no
