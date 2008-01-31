Return-Path: <linux-kernel-owner+w=401wt.eu-S934865AbYAaSVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934865AbYAaSVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 13:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765113AbYAaSVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 13:21:30 -0500
Received: from orion2.pixelized.ch ([195.190.190.13]:43282 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765357AbYAaSV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 13:21:29 -0500
Message-ID: <47A21195.8000401@cateee.net>
Date: Thu, 31 Jan 2008 19:21:09 +0100
From: Giacomo Catenazzi <cate@cateee.net>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kernel bug at drivers/ide/ide-cd.c:1726 on lastest git
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've a kernel bug since few days, but I've not yet had time to bisect.

The output is in:
http://cateee.net/kernel/dsc00169.jpg

ciao
	cate
