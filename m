Return-Path: <linux-kernel-owner+w=401wt.eu-S933159AbYBNMEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159AbYBNMEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 07:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757821AbYBNMEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 07:04:33 -0500
Received: from mail.gmx.net ([213.165.64.20]:38153 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757800AbYBNMEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 07:04:32 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+A63dCBS2AR9d6/7+tR3MKFTRv9Kdnsrbgva4NXR
	BJRf1twum1oacH
Subject: latest git pull (96b5a46..e760e71) kbuild failure
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 13:04:29 +0100
Message-Id: <1202990669.2052.8.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_MARKERS set, modpost griped about unknown option -- K.

	-Mike

