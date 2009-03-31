Return-Path: <linux-kernel-owner+w=401wt.eu-S1761437AbZCaAb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761437AbZCaAb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 20:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755694AbZCaAbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 20:31:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:65470 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbZCaAbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 20:31:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniele Napolitano <dnax88@gmail.com>
Subject: Re: Additional USB identifier for rt2870 driver
Date: Tue, 31 Mar 2009 02:30:27 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <15d0b9b20903301624j45040f38tdd1ce5400bbaa247@mail.gmail.com>
In-Reply-To: <15d0b9b20903301624j45040f38tdd1ce5400bbaa247@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903310230.27755.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19LlTnxa4MqWoIs1L8Dg4MoK/+0ojzpjC0ynK9
 Mq83US8ucTht/PGlG5/HPMt3poS9ffTCg+mRRR0aJfSqH93JCB
 vqehEV0f4Sj2ZvpFf4wjw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 March 2009, Daniele Napolitano wrote:
> --- rt2870.h 2009-02-07 01:27:09.000000000 +0100
> +++ rt2870.h~ 2009-02-07 01:26:58.000000000 +0100

This patch does not apply with -p1, please make sure that you generate
your files according to Documentation/SubmittingPatches in the future.

As this is a patch for a staging driver, you should also Cc
Greg Kroah-Hartman <gregkh@suse.de>, because he is maintaining
the staging drivers.

	Arnd <><
