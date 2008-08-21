Return-Path: <linux-kernel-owner+w=401wt.eu-S1758676AbYHUORU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbYHUORU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbYHUORJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:17:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:53674 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbYHUORI (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:17:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Jared Hulbert" <jaredeh@gmail.com>
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Date: Thu, 21 Aug 2008 16:14:52 +0200
User-Agent: KMail/1.9.9
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>, carsteno@de.ibm.com,
       Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?utf-8?q?J=C3=B6rn?= Engel" <joern@logfs.org>, tim.bird@am.sony.com
References: <48AD00C4.6060302@gmail.com> <200808211453.26233.arnd@arndb.de> <6934efce0808210712u36144c78mb7f1998414a549cf@mail.gmail.com>
In-Reply-To: <6934efce0808210712u36144c78mb7f1998414a549cf@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808211614.53261.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/FU/WHAa/HlqQsv3i1Rg7AMGtk6g8n0XIhrXL
 4b9EBDOOJDa48+FiGbT2Oos25Af9bgRHA3aFVpYyTmAkLC/CXq
 cBGzWpQq/lOAqN7TUcceg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008, Jared Hulbert wrote:
> > One thing that would be really nice is if you could add fake-write
> > support in the way that I proposed for cramfs a few months ago.
> > This would make axfs much more interesting for another set of
> > users, and keep cramfs a really simple example file system.
> 
> Did that get merged?

No, there were a few remaining issues that I never found the time
to work on.

	Arnd <><
