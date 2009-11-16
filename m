Return-Path: <linux-kernel-owner+w=401wt.eu-S1752161AbZKPGx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbZKPGx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 01:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbZKPGx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 01:53:58 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:59481 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbZKPGx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 01:53:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=Dn8x+OtGAhFyLDJBYumC3crMGddJWOvRI4scios2A+UKSixOpa5k/hTp8HpC1oMZ/8
         Qfflj6OUNZH4m95PbNkyeX9BH0Jz4d/mnS+5NQespbQRIM/fWb6cbmc7UKSEN8Vl5Nhx
         kyavHAYu18FaHrTqvoGQ13ddZFwS5Y2G9WbQI=
Subject: Re: [PATCH 00/19] OMAP: DSS2: Intro
From: Gregoire Gentil <gregoire@gentil.com>
Reply-To: gregoire@gentil.com
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: tomi.valkeinen@nokia.com, ext Andrew Morton <akpm@linux-foundation.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <94a0d4530910070157v2dd8062aheffc6345daff9e78@mail.gmail.com>
References: <1253793384-31158-1-git-send-email-tomi.valkeinen@nokia.com>
	 <1254302501.23991.90.camel@tubuntu>
	 <94a0d4530910070157v2dd8062aheffc6345daff9e78@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Gregoire Gentil
Date: Sun, 15 Nov 2009 22:54:01 -0800
Message-Id: <1258354441.19798.10.camel@gregoire-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 11:57 +0300, Felipe Contreras wrote:
> On Wed, Sep 30, 2009 at 12:21 PM, Tomi Valkeinen
> <tomi.valkeinen@nokia.com> wrote:
> > Hi,
> >
> > Andrew, do you have time to check out the DSS2 driver? Or suggestions
> > how should I proceed.
> >
> > I rebased DSS2 on top of today's linux-tree, and there were no
> > conflicts, so the posted patches should apply. But the rebased tree is
> > also available in master branch at
> > git://gitorious.org/linux-omap-dss2/linux.git
> 
> It's also worth noting that DSS2 is used basically on all linux-omap
> trees already, I've seen it working at least on N900 and beagleboard
> and it makes no sense to try to get some video output without it.
> 
> P.S. I had to patch the beagleboard support from Tomi's
> 'master-before-squash'... it would be nice to get it upstream already
I second Felipe on this one. DSS2 is a very stable and an ideal video
driver for OMAP3. Hopefully, it will make upstream soon,

Grégoire



