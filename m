Return-Path: <linux-kernel-owner+w=401wt.eu-S1763601AbYGBLBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763601AbYGBLBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756358AbYGBLBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:01:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755959AbYGBLBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:01:36 -0400
Date: Wed, 2 Jul 2008 04:01:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi@qumranet.com>
Subject: Re: [-mmotm] some different buliding failures
Message-Id: <20080702040127.779a25c5.akpm@linux-foundation.org>
In-Reply-To: <486B1EE0.9060303@cn.fujitsu.com>
References: <486B1EE0.9060303@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK, I uploaded another mmotm (http://userweb.kernel.org/~akpm/mmotm/). 
It passes i386 allnoconfig and allmodconfig.  Heaven knows what it does
at runtime.  We'll take a look at that tomorrow.

People have been madly adding new warnings.  I don't know how this
happens.

kvm is particularly noisy.
