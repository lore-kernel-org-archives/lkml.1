Return-Path: <linux-kernel-owner+w=401wt.eu-S1753161AbYIKE3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbYIKE3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 00:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbYIKE3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 00:29:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55160 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbYIKE3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 00:29:48 -0400
Message-ID: <48C89ECD.6050900@manoweb.com>
Date: Wed, 10 Sep 2008 21:30:05 -0700
From: Alessio Sangalli <alesan@manoweb.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: 8MB physical memory allocation
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+t6aInhKE3prP0xdUGXPl7jNTfYuRWgomy6FV
 bHK7o7va4y1Nfsf6XOwEgbqVG/6xHKXdBMlSf6cncAjDC0sq4u
 Xi0VcNHvhKjhWBnWHkz9Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I'm writing a driver for a video adapter that needs to allocate 8MB
(maximum resolution) in physical, contiguos memory. I am working on a
ARM9 platform.

I guess the only way to go is alloc_bootmem(). Any other solution that
may be recently introduced?

bye
as

