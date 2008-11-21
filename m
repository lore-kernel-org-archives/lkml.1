Return-Path: <linux-kernel-owner+w=401wt.eu-S1756517AbYKUVo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbYKUVo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 16:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbYKUVoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 16:44:14 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:58041 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbYKUVoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 16:44:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id:reply-to;
        b=TcDM0GV6FUp7MzxlAlEmzgSI/j3C1Wv6fH4Oc8BPT5H7mO1IFb5A75eAlYDK6BcHaY
         lQLN53T8lVSiZrZqY9neVLgv6xfr9jn/qqWaKQ8meTlJ/P6j9thfIttbzogpUq6ehuWn
         52oOoXMRhEgosiEHfOI/K29NnXQz4NCuDgY34=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 00/03] ide misc leftovers
Date: Fri, 21 Nov 2008 21:41:32 +0100
User-Agent: KMail/1.9.10
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1227159683-2487-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1227159683-2487-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811212141.32809.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 November 2008, Borislav Petkov wrote:
> Hi Bart,
> 
> here is Linus' reworked ide-floppy reduce-stack-usage patch. It has been tested
> here on current pata tree with your latest 3 patches adding the per-device
> request queue locks. Along with that are 2 small cleanups.

Thanks, I applied all patches.
