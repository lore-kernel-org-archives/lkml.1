Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbZAIQda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbZAIQda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 11:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbZAIQdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 11:33:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56817 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbZAIQdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 11:33:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dick Hollenbeck <dick@softplc.com>
Subject: Re: New true IDE compact flash driver starting point?
Date: Fri, 9 Jan 2009 17:33:16 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <49659E41.5070001@softplc.com> <200901081318.44188.arnd@arndb.de> <49661B0F.6030206@softplc.com>
In-Reply-To: <49661B0F.6030206@softplc.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901091733.16931.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX184Z+WN6wsJKqGmUothLJfEV8gJm8ngDYtB2fW
 PeNMqk9Nb0CRgRbr3qHmwi5LCGFoTFUqnNcgs9O3JsxPg5It39
 VA62jhMm094NcrTV9+ghQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 January 2009, Dick Hollenbeck wrote:
> I've done something similar to this for 8250 serial ports, but I am 
> having a difficult time finding out how to do this with pata_platform.c
> 

Just grep for pata_platform_info to find example code.

	Arnd <><
