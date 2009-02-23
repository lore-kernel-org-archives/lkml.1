Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbZBWGRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbZBWGRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 01:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZBWGRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 01:17:31 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:56567 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbZBWGRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 01:17:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=wahJShWBg4jOXEB3FJfX75pcH51Ir9skTusq8zBAdttDVRhdT7e345NMm7K5nSVMgu
         7mih8Yi6vXiX9Z8gQ6f2qsY2T5a/g66hmrFiqBw1PiLUN0m29JBfdY8uTpYkKDj+BwSW
         bRPBGWd7R2jK3VuTok9HIoJxlg7lCYeZ5GQhA=
Message-ID: <49A23F8B.10104@devnull.org>
Date: Mon, 23 Feb 2009 08:17:47 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Eric Anholt <eric@anholt.net>,
       "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: i915: drm:i915_wait_irq EBUSY
References: <c80p2-1D2-13@gated-at.bofh.it> <c8Asv-87u-7@gated-at.bofh.it>
In-Reply-To: <c8Asv-87u-7@gated-at.bofh.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2009 06:20 AM, Eric Anholt wrote:
> The chip is hung.  Don't use XAA -- it hasn't been the default or even
> supported while your chipset has existed.
> 

Sure, I needed to do that temporarily to address a startup crash in
opera, didn't know it was no longer supported though so I thought I'd
report it.

cheers
Niel
