Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbYDHNmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbYDHNmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 09:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYDHNmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 09:42:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:58594 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbYDHNmU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 09:42:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>
Subject: Re: [patch 1/15] Makefiles and Kconfig
Date: Tue, 8 Apr 2008 15:41:59 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
References: <20080401181308.512473173@logfs.org> <200804080230.17426.arnd@arndb.de> <20080408083316.GA31262@logfs.org>
In-Reply-To: <20080408083316.GA31262@logfs.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804081542.00333.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Wj8B3TS+X0zFzWE1QIF3Cmgh62qPvLSlSJ1C
 oN9N3qbcO1QQLHgTI/1OwmgCimWIfFskoXcoRfrSTQ//m7o/w9
 pzC8EZbfo3gll/RF144Nw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 April 2008, Jörn Engel wrote:
> "Logfs file system" might make sense.  LOGFS_FS is something I would
> rather avoid.  For some reason my brain reacts strongly to repetition,
> redundancy and superfluous information.
> 

How about LOG_FS then? I don't think there is a really good argument
either way, but a large majority uses the *_FS notation in Kconfig.

	Arnd <><
