Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbYIJOjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbYIJOjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 10:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbYIJOjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 10:39:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61491 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYIJOjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:39:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "James Molloy" <james@jamesmolloy.co.uk>
Subject: Re: OpenPIC specification
Date: Wed, 10 Sep 2008 16:39:06 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <d55ad6500809100556u12955cfej1c597d4300c4df15@mail.gmail.com> <d55ad6500809100614m61a6576cg77d14d29557ef4cb@mail.gmail.com>
In-Reply-To: <d55ad6500809100614m61a6576cg77d14d29557ef4cb@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809101639.06863.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/7h7QoTPeimGRSc0m+dNeKPPgtqx/uW2aMiX7
 CEZAjoZwMQN5tOGlzjuv9LzVMIFAzaCHBo/k87uvl2jQw5JJcG
 Pg2/bF9ZQwarvwF7NNwKg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2008, James Molloy wrote:
> I noticed in the LKML archives that the document seems to get passed
> around via private emails - would it be at all possible for someone to
> kindly email me the spec?
> 

I don't have specs that I can send you, but I can suggest that you
take a look at the arch/powerpc/sysdev/mpic.[ch] code, which implements
it for powerpc. mpic is the most common (only?) implementation of openpic.

	Arnd <><
