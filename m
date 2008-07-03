Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbYGCMPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbYGCMPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYGCMO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:14:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59643 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbYGCMO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:14:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: Current List of Kernel Summit suggested topics from the discuss list
Date: Thu, 3 Jul 2008 11:29:04 +0200
User-Agent: KMail/1.9.9
Cc: ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1214577710.3394.14.camel@localhost.localdomain>
In-Reply-To: <1214577710.3394.14.camel@localhost.localdomain>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807031129.05165.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+M94l67PtUSZbD5OM12JUbnHBcwKWR05H6GjL
 N2vHeBqdaPHkkFl6z/2TI3jtZ/y+Y8gQoXQluJlFbCvFoZDABW
 OaINcizWsZN+6GdDU2f1w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 June 2008, James Bottomley wrote:

> Agenda Topics:
> 
>      1. Asynchronous Operations - Ulrich Drepper
>               * How do we make programs more parallel (driven by
>                 multicore)
>               * Can we use tasklets for this

I suppose you mean "threadlets" or "syslets" here, not "tasklets",
which are a kernel internal concept, right?

	Arnd <><
