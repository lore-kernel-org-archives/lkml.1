Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbYB0U50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbYB0U50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 15:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbYB0U5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 15:57:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:63253 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbYB0U5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:57:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:cc:subject;
        b=sOCeQaPectX01kj0IwmDZYIgMA5vhBXeDqrbZfvHOWketVKONa7M/g1UNM+B/8jR5umW5AZf55tAHBDGZzTUk1nQWjqnJ24VEVf8hUagyTq6pcho4BqbtUScaWq2re6kFN4pPkJNVKP69j7LMcb+XloH9HKSbw+57RSo+BFFrYo=
Message-Id: <20080227204840.183335270@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 27 Feb 2008 23:48:40 +0300
From: gorcunov@gmail.com
To: rth@twiddle.net, chris@zankel.net, jdike@addtoit.com,
       linuxppc-dev@ozlabs.org, paulus@samba.org, dhowells@redhat.com,
       zippel@linux-m68k.org, geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org,
       linux-kernel@vger.kernel.org
Cc: gorcunov@gmail.com, sam@ravnborg.org
Subject: [RFC 0/0] vmlinux cleanup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches is made in purpose to use PAGE_SIZE and THREAD_SIZE
macroses in vmlinux linker scripts as much as possible instead of numeric
constants. Please review.

	WARNING: the patches are UNTESTED COMPLETELY - I've no access to
	that architectures and errors is highly possible ;)

	If you have an ability to test this patches - please do it.
	What is most important on review - these macroses *must* be
	placed into appropriate places - check it please.

	ANY comments are welcome.

		- Cyrill -
-- 
