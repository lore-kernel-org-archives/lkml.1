Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbZHNOAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbZHNOAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 10:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbZHNOAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 10:00:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65408 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbZHNOAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 10:00:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefani Seibold <stefani@seibold.net>
Subject: Re: [PATCH 1/6] new kfifo API v0.3 - Code reorganization and move out spinlock
Date: Fri, 14 Aug 2009 16:00:11 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>
References: <1250250189.19690.92.camel@wall-e>
In-Reply-To: <1250250189.19690.92.camel@wall-e>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908141600.11881.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/zG6w3VQQ1h05UEQLO5hI837Qal6noZ4CrZK4
 2wNgLxGQ1/kNsPRO4IxLBcw4gE6zi6IL6aFXr6gYucScpKHNJr
 3d9eXkKn7ggwxbCumXpwQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 August 2009, Stefani Seibold wrote:

> Signed-off-by: Stefani Seibold <stefani@seibold.net>

Acked-by: Arnd Bergmann <arnd@arndb.de>
