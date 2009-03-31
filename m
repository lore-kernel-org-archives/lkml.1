Return-Path: <linux-kernel-owner+w=401wt.eu-S1760279AbZCaARV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760279AbZCaARV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 20:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbZCaARJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 20:17:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63150 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbZCaARI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 20:17:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/8] MAINTAINERS - add script and patterns
Date: Tue, 31 Mar 2009 02:16:22 +0200
User-Agent: KMail/1.9.9
Cc: Joe Perches <joe@perches.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, pavel@ucw.cz
References: <1237331969-28565-1-git-send-email-joe@perches.com> <20090330135315.a05854da.akpm@linux-foundation.org>
In-Reply-To: <20090330135315.a05854da.akpm@linux-foundation.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903310216.23550.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+e5hiBCDeXKf9EhhibuvYfLGZ3D4BAH5VZiCe
 kzIp30HB0lGjI3+Qn1MIQezvyIg+kilB7TL95zjzkEBMVbgq5T
 bDfUpJ0KMBldvfBxhiYhQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 March 2009, Andrew Morton wrote:
> Is everyone OK with the concept and execution?  We think this is ready
> and desirable to merge?

I like the patches a lot, and i believe that Joe did a great job at
compiling the file name lists.

> I never have seen [patch 2/8] because the linux-foundation mail server
> thinks it's spam.

That's probably because of the size of the mail (140kb). It is really
the patch that has most of the value of this series, IMHO, by
giving a static file list for each MAINTAINER entry.

	Arnd <><
