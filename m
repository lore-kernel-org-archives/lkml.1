Return-Path: <linux-kernel-owner+w=401wt.eu-S1764044AbZD3Qu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764044AbZD3Qu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 12:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932286AbZD3Quq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 12:50:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64276 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760151AbZD3Quo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 12:50:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 08/27] asm-generic: add generic versions of common headers
Date: Thu, 30 Apr 2009 18:49:44 +0200
User-Agent: KMail/1.9.9
Cc: linux-arch@vger.kernel.org, monstr@monstr.eu,
       remis.developer@googlemail.com, linux-kernel@vger.kernel.org
References: <cover.1241105648.git.arnd@arndb.de> <265d330107973ffda3b4b8a3c26ec93f31dfdf00.1241105648.git.arnd@arndb.de> <20090430.094129.39981996.davem@davemloft.net>
In-Reply-To: <20090430.094129.39981996.davem@davemloft.net>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904301849.45543.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18vrkKjQ80AgLdSfK/aj+JcMW0RRwnFl9CEPfv
 4h9/6SiZ3tGRlJw6NpB0xxm3YbFhpRa6Luk80lMwl3QKHs8Z2B
 oa9bjt2uHVxKPoS/1YWww==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 April 2009, David Miller wrote:
> Many sites are bouncing because the date on your emails is
> as much as two days in the past.

Any suggestions on which tool I should use? I've been burned by
both 'quilt mail' and 'git-format-patch' this week and don't want
to make any more experiments. I looked at git-send-email, but
I'm sure I'd screw up even more with that because it directly
sends out the patches rather than giving me an mbox file to look
at.
	Arnd <><
