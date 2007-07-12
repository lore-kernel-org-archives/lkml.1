Return-Path: <linux-kernel-owner+w=401wt.eu-S1764819AbXGLK3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764819AbXGLK3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 06:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760341AbXGLK32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 06:29:28 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:58206 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760068AbXGLK31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 06:29:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=X2fIetjcaOO7t9SS78gElCQwgaHhAmaoK6Dgn8Cu0i5QNWnSiuqKMyy0iuDgMAfcvr/Mb598mTFyiyYipKPdGSkUOO//btwnuYgdBjqkpQUwb620zc8kHZoQsUoB1uAOZEKSa2w2QtzxD10LegNBEr2VTwhL5X3WyJvQRZBSH7c=
Subject: RE: [PATCH][ACPI][BUTTON] remove procfs-interface
From: Richard Hughes <hughsient@gmail.com>
To: "Zhang, Rui" <rui.zhang@intel.com>
Cc: Henne <henne@nachtwindheim.de>, Arjan van de Ven <arjan@infradead.org>,
       "Brown, Len" <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <823A93EED437D048963A3697DB0E35DE7314AB@pdsmsx414.ccr.corp.intel.com>
References: <823A93EED437D048963A3697DB0E35DE7314AB@pdsmsx414.ccr.corp.intel.com>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 11:26:09 +0100
Message-Id: <1184235969.2415.0.camel@work>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 17:46 +0800, Zhang, Rui wrote:
> 
> I'm not sure if the button sysfs I/F is already finished.
> We'd better make a double check. :)

We need a button sysfs interface? What's wrong with just using input?

Richard.


