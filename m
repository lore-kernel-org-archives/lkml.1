Return-Path: <linux-kernel-owner+w=401wt.eu-S1752131AbZGYQgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbZGYQgA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 12:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbZGYQf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 12:35:59 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:41868 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZGYQf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 12:35:59 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] Add function to convert between calendar time and broken-down time for universal use
References: <4A5C3BC0.6020701@cn.fujitsu.com>
	<20090714151040.b7b3b26d.akpm@linux-foundation.org>
	<20090718115019.GH1433@ucw.cz>
	<04e101ca08e5$be078fa0$808410ac@zhaoleiwin>
	<20090719202018.497f7ec1.akpm@linux-foundation.org>
	<4A643EFE.7090103@cn.fujitsu.com> <4A643F36.5090200@cn.fujitsu.com>
	<87ocr9mi8h.fsf@devron.myhome.or.jp>
Date: Sat, 25 Jul 2009 17:50:50 +0900
In-Reply-To: <87ocr9mi8h.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Sat, 25 Jul 2009 14:42:06 +0900")
Message-ID: <877hxxm9hx.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

> Are you going to fix it? Otherwise I don't think it would not be good to
> use it easily as generic function like this.

s/I don't think/I think/
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
