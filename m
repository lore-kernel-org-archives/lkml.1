Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbYDHVrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbYDHVrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 17:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbYDHVrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 17:47:23 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:37432 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbYDHVrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 17:47:22 -0400
Message-ID: <007901c899c2$1df6ae30$6400a8c0@bui.materna.com>
From: "Roland" <devzero@web.de>
To: <rogerheflin@gmail.com>, <joel.greene@catapult.com>
Cc: <linux-kernel@vger.kernel.org>, <pavel@ucw.cz>
Subject: Re: Clock has stopped (time/date looping over 5 secon
Date: Tue, 8 Apr 2008 23:47:17 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-Provags-ID: V01U2FsdGVkX1+/8FT+Ym/d6lA/XD+mH475SS2TrGi/jGuo29Qe
	5n9mT+md5B/iZbr4oY0OuwkfqFAY3rXFR34amqCael1IGPma2j
	hkccPwisw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It _appears_ that there is a race in the kernel that can be triggered by
> any number of hardware issues. There's another thread by Gregory Stark
> with the same symptoms - he thinks his was fixed by replacing a bad
> DIMM.

i`d like to mention that we may have a repro-case (if it`s the same issue i 
hit within vmware):

see http://communities.vmware.com/message/909403

regards
roland



