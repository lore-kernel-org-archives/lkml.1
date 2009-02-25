Return-Path: <linux-kernel-owner+w=401wt.eu-S1761356AbZBYVoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761356AbZBYVoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756588AbZBYVoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:44:01 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49821 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889AbZBYVoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:44:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Make exported headers use strict posix types
Date: Wed, 25 Feb 2009 22:42:44 +0100
User-Agent: KMail/1.9.9
Cc: Kyle McMartin <kyle@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
References: <20090225032553.GD6690@bombadil.infradead.org> <200902251917.49017.arnd@arndb.de> <20090225201131.GA26110@uranus.ravnborg.org>
In-Reply-To: <20090225201131.GA26110@uranus.ravnborg.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902252242.45755.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+sHqy8LxTo6oSL6+LdRvydxGxwipRooAgrMAW
 ajcHLEx9VnHXF8PYOmrquurwKF9h8uR9Aq+MIFCFiUkdFUKL9b
 ypzfS/mwRRLj75Qi0uDBQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 February 2009, Sam Ravnborg wrote:

 
> Does this change really belong in this patchset?
 
> Yes - I can build kernels again. But I think we should skip this change..

> This change looks correct - but I assume this is a separate patch.
> 
> Rest looks good.

Agreed on all points, I had the changes sitting in a dirty git tree
and got sloppy. Thanks for looking through it!

	Arnd <><
