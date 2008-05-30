Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbYE3Wey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbYE3Wey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 18:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbYE3Wem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 18:34:42 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:49049 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936AbYE3Wel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 18:34:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=x7riIYGbgn2jmd5PIP33oh+Jo5/aoAS4iSCyJ8C8aWBEcOaX4zXwRCvxv9Ov9Ic4FJNOIu0m7HnjEMoGI+5jjE9jxma7LImo2WY0iDKez48PbyUIqNb5u9Bi0GDKdcdFdW9NZEb8Z9DDrRAQGDdjscxrSEWoiKDwCQRaitDiX5g=
Message-ID: <ef1cd66f0805301534t2dca0f4eh97dac71e10d3d683@mail.gmail.com>
Date: Fri, 30 May 2008 23:34:40 +0100
From: "=?ISO-8859-1?Q?Jochen_Vo=DF?=" <jochen.voss@googlemail.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>
Subject: Re: Top kernel oopses/warnings for the week of May 30th 2008
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48402DAA.60202@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48402DAA.60202@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

2008/5/30 Arjan van de Ven <arjan@linux.intel.com>:
> Rank 2: sysfs_add_one (warning)
>        Reported 243 times (759 total reports)
[...]
> Rank 3: mark_buffer_dirty (warning)
>        Reported 222 times (759 total reports)

It seems like a strange coincidence that the first two entries have
the same number of total reports.  Is this really the case or is there
something mixed up?

All the best,
Jochen
-- 
http://seehuhn.de/
