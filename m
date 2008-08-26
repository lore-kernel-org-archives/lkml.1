Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbYHZOnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbYHZOnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 10:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbYHZOnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 10:43:03 -0400
Received: from mlbe2k2.cs.myharris.net ([137.237.90.89]:37615 "EHLO
	mlbe2k2.cs.myharris.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbYHZOnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 10:43:02 -0400
Message-ID: <48B4159A.9070907@harris.com>
Date: Tue, 26 Aug 2008 10:39:22 -0400
From: "Steven A. Falco" <sfalco@harris.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alessandro Zummo <alessandro.zummo@towertech.it>
CC: rtc-linux@googlegroups.com, will.newton@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: [RFC] Driver for Real Time Clock chip ST M41T65
References: <48B2EB77.9000103@harris.com>	<87a5b0800808260130i383ec8d0y45690f85366c5059@mail.gmail.com>	<48B40B68.1040607@harris.com>	<87a5b0800808260700g52cedf59kb07880ae05a104b@mail.gmail.com> <20080826161353.6326f6e2@i1501.lan.towertech.it>
In-Reply-To: <20080826161353.6326f6e2@i1501.lan.towertech.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Aug 2008 14:39:23.0342 (UTC) FILETIME=[882E4EE0:01C90789]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alessandro Zummo wrote:
> On Tue, 26 Aug 2008 15:00:03 +0100
> "Will Newton" <will.newton@gmail.com> wrote:
> 
> 
>>>> On Mon, Aug 25, 2008 at 6:27 PM, Steven A. Falco <sfalco@harris.com> wrote:
>>>>> I will be using a Real Time Clock chip, ST M41T65, on a new embedded system.
>>>>> The chip is quite similar to the M41T8x family, which already has driver
>>>>> rtc-m41t80.c.
>>>>>
>>>>> Would it be more acceptible to generalize rtc-m41t80.c (perhaps renaming it to
>>>>> rtc-m41txx.c) or would it be better to create a new rtc-m41t6x.c?
>>> Thanks for the feedback.  Here is a respin which addresses your comments.
>>>
>>> I'd also like to know if I should submit a new driver or mod the existing
>>> one.  If I mod the existing one, should it be renamed, should I update the
>>> Kconfig, existing defconfigs, etc?
> 
>  Given the small amount of changes, I would use the existing driver without
>  renaming it.
> 

Sounds good.  Please let me know if there are other changes needed to make this
patch acceptable for inclusion into the mainline.

	Steve

