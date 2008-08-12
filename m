Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbYHLWAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbYHLWAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 18:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbYHLWAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 18:00:23 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:26144 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbYHLWAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 18:00:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Y8h1f/EjfV6sX9wZy8VmG30AsRBvzFQNoOTjELXAGWIBLIknFAnzhccaFCxCG2cvRQ
         ZGjW/MOwu0d34c2ijLgauSYL/tx/US/2uveTOkGHvD17e3HkMyXDmY583U5BqNUJ/DGM
         4qs863pll5ITfUCT0Pqe11z4luPQtNgmKj2Wk=
Message-ID: <b170af450808121500j75cd82bev43e8c232e8c14e42@mail.gmail.com>
Date: Wed, 13 Aug 2008 00:00:19 +0200
From: "=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?=" <zajec5@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bugme-new] [Bug 11313] New: Plugging HDMI causes "unable to handle kernel paging request"
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200808122359.58924.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <bug-11313-10286@http.bugzilla.kernel.org/>
	 <20080812144406.0c8aff48.akpm@linux-foundation.org>
	 <200808122359.58924.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m7CM0bdq023085

12-08-08, Rafael J. Wysocki <rjw@sisk.pl> napisaÅ‚(a):> On Tuesday, 12 of August 2008, Andrew Morton wrote:>> ugh.  Random rampant memory corruption caused by unplugging an HDMI>> cable?  I'm not even sure which subsystem could be involved here.>> Hm.  Isn't that X trying to access memory which is not mapped?>> RafaÅ‚, which graphics driver are you using?
I use radeonhd from today morning git. Does it matter as I play (plug,unplug) with HDMI in init 3?
I'll try bisecting tomorrow.
-- RafaÅ‚ MiÅ‚eckiÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
