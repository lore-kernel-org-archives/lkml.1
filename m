Return-Path: <linux-kernel-owner+w=401wt.eu-S1762408AbZBYLCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762408AbZBYLCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 06:02:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760386AbZBYLCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 06:02:32 -0500
Received: from p-mail2.rd.francetelecom.com ([195.101.245.16]:4487 "EHLO
	p-mail2.rd.francetelecom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757513AbZBYLCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 06:02:32 -0500
X-Greylist: delayed 2560 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Feb 2009 06:02:31 EST
Message-ID: <49A52555.8070404@Free.fr>
Date: Wed, 25 Feb 2009 12:02:45 +0100
From: Eric Valette <Eric.Valette@Free.fr>
Reply-To: Eric.Valette@Free.fr
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Some user feedback on recent Intel chipset and 2.6.29 KMS
References: <49A51B4D.5070903@Free.fr> <21d7e9970902250237i13f20336ib0176ed2b0edd7f4@mail.gmail.com>
In-Reply-To: <21d7e9970902250237i13f20336ib0176ed2b0edd7f4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Feb 2009 11:02:27.0941 (UTC) FILETIME=[8BFDF950:01C99738]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
> See if the attached patch helps resume, there are also some other patches
> queued for Linus in my drm-fixes tree. I sent the pull req earlier.
>   

Thanks for the quick anwser.

I will test the individual patch as soon as I get back home and report.
For the earlier pull, I will probably wait until its available in a
2.6.29-rc6-gitx and report. Do you want separate reports or testing the
whole stuff?

Any idea/hint about the redraw problem that seems to need
scheduling/interrupts activity to take place? (note I have probably
selected a tickless setting to have a better battery consumption). Does
the "earlier pull" modifications have any chance of fixing it?

-- eric

