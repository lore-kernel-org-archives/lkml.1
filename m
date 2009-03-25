Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbZCYM6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbZCYM6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbZCYM6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:58:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57814 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbZCYM6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:58:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: RDMA/InfiniBand merge plans for 2.6.30
Date: Wed, 25 Mar 2009 13:58:05 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org,
       Eli Cohen <eli@mellanox.co.il>
References: <ada4oxiwa1y.fsf@cisco.com>
In-Reply-To: <ada4oxiwa1y.fsf@cisco.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903251358.06128.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/LkDDwaqVZpT0JYK/0EM/uFjv8yrOK4HTsHn1
 kStc5ZtL5nfjYCZU6+UplGWT70LicaeF27Ho6rsP5Tt5XllWiS
 KQoGaP9WMUe/hNSpYyxGg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 March 2009, Roland Dreier wrote:
> Since 2.6.29 is out, I should update everyone on 2.6.30 merge plans.
> All the pending things that I'm aware of are listed below.  As usual, if
> something isn't already in my tree and it isn't listed below, I probably
> missed it or dropped it unintentionally.  Please remind me again.

There are some patches in the ofed release by Eli and me to support
weak ordering on DMA ("ib_core: Use weak ordering for data registered
memory"). When they got merged into OFED, I assumed they would find
their way into mainline along with most of the other patches in there.

Did they get forgotten about, or did I misunderstand the process?

	Arnd <><
