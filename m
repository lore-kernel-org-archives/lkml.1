Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbZISUhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbZISUhy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 16:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbZISUhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 16:37:53 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:54852 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbZISUhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 16:37:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=v0iIQgPWUq2/XiSXhUzj9VQqb3mTMNNxKAS/5Khm7Ucfq7bwiyPls2M1mcg8u3/NDK
         Tym5al/1J8QHgShS98mtVwbtIu2cmN517bZoF4KI1KCZb3LlKKERsC4IS4Wuu7NhbI+y
         iZfbaLCDuJj6n7U2z9ashwD4ENHkaHEnvCH+k=
References: <4AB48658.2080709@nickg.me.uk>
Message-Id: <E90F5632-5476-4D73-A848-B3A4762FEA86@gmail.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nick Gasson <nick@nickg.me.uk>
In-Reply-To: <4AB48658.2080709@nickg.me.uk>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7C144)
Mime-Version: 1.0 (iPhone Mail 7C144)
Subject: Re: [PATCH] Fix fn-key release events for Samsung Q320 laptop
Date: Sat, 19 Sep 2009 13:37:42 -0700
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Sep 19, 2009, at 12:20 AM, Nick Gasson <nick@nickg.me.uk> wrote:

> This adds a workaround for the missing fn-key release
> events on Samsung Q320 and similar laptops.
>
> Tested extensively on my own laptop.
>
> Signed-off-by: Nick Gasson <nick@nickg.me.uk>

Thank you very much for your patch, hovewer I will not be accepting  
any more patches for the force release quirk in the kernel. 2.6.32  
will have 'force_release' sysfs attribute allowing to apply the quirk  
from userspace.

-- 
Dmitry

