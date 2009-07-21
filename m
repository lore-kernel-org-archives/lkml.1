Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbZGUMIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbZGUMIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 08:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbZGUMIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 08:08:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:63237 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbZGUMIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 08:08:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: virtualization@lists.linux-foundation.org
Subject: Re: [patch 00/54] [Announce] Microsoft Hyper-V drivers for Linux
Date: Tue, 21 Jul 2009 14:07:40 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.96; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Andi Kleen <andi@firstfloor.org>,
       devel@driverdev.osuosl.org, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org
References: <20090720160025.GA20249@kroah.com> <871vob4047.fsf@basil.nowhere.org> <20090720195754.GB30483@suse.de>
In-Reply-To: <20090720195754.GB30483@suse.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907211407.40229.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/bF9LX6JmZBgM+Fb+yw9n4ThGkG2SYeig2ABL
 3yicTh4FKB+K/njz+y9sWF3v5jt2+XQfYTyeSQZi+wbmH/TUGf
 FzjqOR5TmbQ3v9kdD7a7WgpfA4NIDMh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 July 2009, Greg KH wrote:
> Anyway, I agree, for a "proper" review, I will show the final, cleaned
> up version, like normal.  But we aren't there just yet, that is why this
> code is going to live in the staging tree for a while.  Give us some
> time to get it fixed up.

I would find it helpful to have them in a git tree (or a branch) that
I can pull, so I can look at both the original code and the cleaned up
state.

Any reason why the patches are not yet in your staging.git?

	Arnd <><
