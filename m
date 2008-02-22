Return-Path: <linux-kernel-owner+w=401wt.eu-S1762974AbYBVAwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762974AbYBVAwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756961AbYBVAwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:52:14 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:9652 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936410AbYBVAwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:52:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZzBYvz5QnjM/wCzI+Lf9R3QTM/Wlr4bCiB4D1TuccpnGM4BskE+sckBbLAUkWnKTed12i818zN5jQc7q87h8zd7iOl6INzkA3XpZ3Xe0nty18m53Zzp5ZnylEfKTyb+1twVUbsU+47jsBQv4redRjlsZs4MyBvLwrN4hTjGGeH4=
Message-ID: <b6a2187b0802211652x304daa2ci36a76a76a2fcb82@mail.gmail.com>
Date: Fri, 22 Feb 2008 08:52:09 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Jesse Barnes" <jesse.barnes@intel.com>
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off aftersuspend-to-disk. Screen becomes green.
Cc: "Romano Giannetti" <romano@dea.icai.upcomillas.es>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Dave Airlie" <airlied@linux.ie>, "Greg KH" <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org
In-Reply-To: <200802211646.31603.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>
	 <200802211623.55450.jesse.barnes@intel.com>
	 <b6a2187b0802211642i17730ccav6744b614c086df72@mail.gmail.com>
	 <200802211646.31603.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 8:46 AM, Jesse Barnes <jesse.barnes@intel.com> wrote:

>  Your s2ram script is doing your STD also?  Seems counterintuitive.  Anyway,
>  some machines also re-POST the GPU on resume from S3; maybe yours is doing
>  that.

It's s2ram to do STR, not STD. Sorry for the confusion. But the key
point is there's no GREEN for STR. Mr Green only appear with STD.

Thanks,
Jeff.
