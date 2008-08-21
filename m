Return-Path: <linux-kernel-owner+w=401wt.eu-S1759224AbYHUL03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224AbYHUL03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 07:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757123AbYHUL0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 07:26:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:62911 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704AbYHUL0Q (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 07:26:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: jaredeh@gmail.com
Subject: Re: [PATCH 02/10] AXFS: Kconfig and Makefiles
Date: Thu, 21 Aug 2008 13:24:22 +0200
User-Agent: KMail/1.9.9
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?iso-8859-1?q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
References: <48AD00DF.9080207@gmail.com>
In-Reply-To: <48AD00DF.9080207@gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808211324.22989.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+qamNVRorEuaY1FkSS33kElhflPiL/PFX9pZH
 kP8WppNWH2F+K5c/QaIjZOE7MaGJx9XqINvlFbXJb0BYAKg/JC
 0m85cdxhuVaiuSjPeGdoQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008, Jared Hulbert wrote:
> The Kconfig edits and Makefiles required for AXFS.
> 
> Signed-off-by: Jared Hulbert <jaredeh@gmail.com>

If you split out this patch separate from the files, please make it the
*last* patch so that you cannot get build errors during a later git-bisect
through the middle of your series.

	Arnd <><
