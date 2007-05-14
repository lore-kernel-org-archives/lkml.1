Return-Path: <linux-kernel-owner+w=401wt.eu-S1760213AbXENUOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760213AbXENUOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760105AbXENUOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:14:31 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:42939 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760080AbXENUOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:14:30 -0400
Date: Mon, 14 May 2007 22:12:51 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Xavier Bestel <xavier.bestel@free.fr>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: tracking down disk spinups.
In-Reply-To: <1179170914.2397.4.camel@bip.parateam.prv>
Message-ID: <Pine.LNX.4.61.0705142212190.9570@yvahk01.tjqt.qr>
References: <20070514185734.GM27604@redhat.com>  <4648B789.7080905@goop.org>
 <1179170914.2397.4.camel@bip.parateam.prv>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14 2007 21:28, Xavier Bestel wrote:
>Le lundi 14 mai 2007 à 12:24 -0700, Jeremy Fitzhardinge a écrit :
>> I don't think you can change filesystem types with remount.  Doesn't
>> that just change flags on an existing mount? 
>
>+1

+2.

Hell, it'd be fun to switch from reiser to xfs by just passing in a -t!


	Jan
-- 
