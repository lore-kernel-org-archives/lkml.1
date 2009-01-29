Return-Path: <linux-kernel-owner+w=401wt.eu-S1758433AbZA2NpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433AbZA2NpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 08:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbZA2Noz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 08:44:55 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:53134 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbZA2Noy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 08:44:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3] timer: implement lockdep deadlock detection
Date: Thu, 29 Jan 2009 14:44:21 +0100
User-Agent: KMail/1.9.9
Cc: Johannes Berg <johannes@sipsolutions.net>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
References: <1233010786.4344.1.camel@johannes.local> <1233166017.4811.9.camel@johannes.local> <1233236287.4495.77.camel@laptop>
In-Reply-To: <1233236287.4495.77.camel@laptop>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901291444.21944.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/PRr7lwgP37mTPt7bFUlqvppDbAPFP9hSj1Sm
 M+0k02PgUwn3uGLITYU4TOERW7tFFcaCLrdixcNic+miZ9IhEW
 kYxny5rMzJNpa+CqGYQVQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 January 2009, Peter Zijlstra wrote:
> I'm sure I saw that stringify thing somewhere in the kernel before, but
> can't find it. I recently added it to lockdep.c, maybe we should add it
> to kernel.h ?
> 

It's in <linux/stringify.h>.

	Arnd <><
