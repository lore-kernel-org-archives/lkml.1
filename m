Return-Path: <linux-kernel-owner+w=401wt.eu-S932989AbZD3RtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989AbZD3RtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764730AbZD3RIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:62676 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764691AbZD3RIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 08/27] asm-generic: add generic versions of common headers
Date: Thu, 30 Apr 2009 19:07:45 +0200
User-Agent: KMail/1.9.9
Cc: linux-arch@vger.kernel.org, monstr@monstr.eu,
       remis.developer@googlemail.com, linux-kernel@vger.kernel.org
References: <265d330107973ffda3b4b8a3c26ec93f31dfdf00.1241105648.git.arnd@arndb.de> <200904301849.45543.arnd@arndb.de> <20090430.095147.208962142.davem@davemloft.net>
In-Reply-To: <20090430.095147.208962142.davem@davemloft.net>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904301907.46515.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/maJnOMjLu/nO9yHH8HhU3eW/RceAzVij09GZ
 8o+oGsdNG9Nn1BTvbTdD7paYMd7RA4npeQbeV3PG3EEPl1AhQm
 dl4xBO1Dpq9hmkv46YJlQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 April 2009, David Miller wrote:
> I use "git format-patch" and send the postings by hand.

That's what I tried as well, but at least with --stdout, git-format-patch
preserves the date and author (From) fields of the changesets, which should
go in the body instead, while exporting the separate patches followed
by 'quilt mail --mbox' drops these fields, in addition to occasionally
screwing up the whole mbox format in the process.

I was hoping to find a simple tool to generate the mbox file in the right
format for importing into the mail client, rather then importing every
single file separately.

	Arnd <><
