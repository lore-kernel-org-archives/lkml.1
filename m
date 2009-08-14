Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbZHNMXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbZHNMXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756603AbZHNMXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:23:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57955 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756601AbZHNMXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:23:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefani Seibold <stefani@seibold.net>
Subject: Re: [PATCH 3/6] new kfifo API v0.3 - rename kfifo_put... -> kfifo_in... and kfifo_get... -> kfifo_out...
Date: Fri, 14 Aug 2009 14:23:15 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>
References: <1250250223.19690.94.camel@wall-e>
In-Reply-To: <1250250223.19690.94.camel@wall-e>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908141423.15731.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+F3tn4Cbt2NbLLABiJ1F6qxz7485Cjg9Jorih
 STs4NN1Vcnbe+O9cl+OTis4rdrSVcXQZs9awMu2hWioAVUShMq
 4Ev1LaziSGgXoEMpdDoAw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 August 2009, Stefani Seibold wrote:
> Signed-off-by: Stefani Seibold <stefani@seibold.net>

Acked-by: Arnd Bergmann <arnd@arndb.de>
