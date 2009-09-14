Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbZINWFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbZINWFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 18:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbZINWFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 18:05:31 -0400
Received: from fifo99.com ([67.223.236.141]:58947 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbZINWFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 18:05:30 -0400
Subject: Re: [patch 3/6] add pmem driver
From: Daniel Walker <dwalker@fifo99.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, arve@android.com, swetland@google.com,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20090914215855.GC11667@elf.ucw.cz>
References: <20090914215855.GC11667@elf.ucw.cz>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 15:06:20 -0700
Message-Id: <1252965980.11643.261.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 23:58 +0200, Pavel Machek wrote:
> 
> This adds android pmem driver, one of dependencies of camera driver.
> 

I wouldn't even both with this one .. There's no way it could ever go
into mainline .. According to the android developers the camera , and
the frame buffer driver should work without it anyway..

Daniel

