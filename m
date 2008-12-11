Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbYLKN3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbYLKN3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 08:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbYLKN3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 08:29:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60790 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300AbYLKN3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 08:29:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] tracehook: exec double-reporting fix
Date: Thu, 11 Dec 2008 14:29:29 +0100
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       "Ulrich Weigand <ulrich.weigand@de.ibm.com>Oleg Nesterov" 
	<oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>
References: <200812091533.10628.arnd@arndb.de> <20081210040423.5EE72FC362@magilla.sf.frob.com>
In-Reply-To: <20081210040423.5EE72FC362@magilla.sf.frob.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812111429.30327.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Gv1baosnH8VKGwaaSNKMCo3h+0jtj01g89mU
 63gVZM7KYFTnvPZTwpsfzoCgCpNr6/j7SGRVZ4C6V51x8nKklT
 vQsfXoNiseixiEweJA6pg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 December 2008, Roland McGrath wrote:
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> CC: Ulrich Weigand <ulrich.weigand@de.ibm.com>
> Signed-off-by: Roland McGrath <roland@redhat.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
