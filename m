Return-Path: <linux-kernel-owner+w=401wt.eu-S1031177AbXDJRJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031177AbXDJRJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 13:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031180AbXDJRJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 13:09:06 -0400
Received: from gw.goop.org ([64.81.55.164]:55244 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031177AbXDJRJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 13:09:05 -0400
Message-ID: <461BC4AF.2010008@goop.org>
Date: Tue, 10 Apr 2007 10:09:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 0/2] updates for percpu allocation and alignment patches
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

It looks like -rc6-mm1 has old versions of
allow-per-cpu-variables-to-be-page-aligned.patch and
x86_64-mm-account-for-module-percpu-space-separately-from-kernel-percpu.patch. 
Up-to-date versions follow.

Thanks,
    J
