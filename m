Return-Path: <linux-kernel-owner+w=401wt.eu-S1763666AbZD3QpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763666AbZD3QpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 12:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbZD3Qou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 12:44:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:61853 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbZD3Qot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 12:44:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: x86@vger.kernel.org
Subject: [PATCH 0/2] use generic headers in x86
Date: Thu, 30 Apr 2009 18:39:08 +0200
User-Agent: KMail/1.9.9
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
References: <cover.1241105648.git.arnd@arndb.de>
In-Reply-To: <cover.1241105648.git.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904301839.08854.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+DvYxPVARB/UAri0Z0Fpcg8NfBPrZXbOceW3L
 BOZkxOF6lPqAmehvBc0vZZrtPMg8fu44LUD9/gNhXT+dpX4mvr
 xLqrmSSz+vf6a1S9nLjsw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once the generic headers are merged, we can apply these
other patches from Remis to use them in x86.

	Arnd <><

