Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbYHQT2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbYHQT2w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbYHQT2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:28:43 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:50130 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbYHQT2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:28:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wFAXXEDaWnCdOmMaqdg1i8YLPMPwuBwYLQgOyemJTPcsosUDn6WeX3lDN06cLCT8qb
         Ug0KueziSGWeGKXdGyvXGc4dYYk0HfJf5AIDhefTTgwD3xkT2YidvYs2ezEcJ4l7autW
         OZ8TZJMWxzYyMZpEtN8dZMm5ZLOggzI40h8AI=
Message-ID: <b170af450808171228i37951c6vd77071da7584669b@mail.gmail.com>
Date: Sun, 17 Aug 2008 21:28:41 +0200
From: "=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?=" <zajec5@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11313] Plugging HDMI causes "unable to handle kernel paging request"
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <sNRO-BDDjQL.A.DYF.sazpIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
	 <sNRO-BDDjQL.A.DYF.sazpIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m7HJSudq032160

2008/8/16, Rafael J. Wysocki <rjw@sisk.pl>:> This message has been generated automatically as a part of a report> of recent regressions.>> The following bug entry is on the current list of known regressions> from 2.6.26.  Please verify if it still should be listed and let me know> (either way).>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11313> Subject		: Plugging HDMI causes "unable to handle kernel paging request"> Submitter	: RafaÅ‚ MiÅ‚ecki <zajec5@gmail.com>> Date		: 2008-08-12 14:30 (5 days old)
Bug still exists in current git (tested 15 minutes ago).
-- RafaÅ‚ MiÅ‚eckiÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
