Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbXDKVHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbXDKVHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 17:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbXDKVHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 17:07:13 -0400
Received: from smtp.osdl.org ([65.172.181.24]:60987 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997AbXDKVHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 17:07:10 -0400
Date: Wed, 11 Apr 2007 14:06:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, corentincj@iksaif.net,
       sziwan@users.sourceforge.net, acpi4asus-user@lists.sourceforge.net,
       len.brown@intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/1] ACPI: asus_acpi, support F2JE model
Message-Id: <20070411140655.6dd2cb3f.akpm@linux-foundation.org>
In-Reply-To: <461D46EF.2040805@gmail.com>
References: <2189310342910921713@karneval.cz>
	<20070411132053.899462b4.akpm@linux-foundation.org>
	<461D45CE.3030309@gmail.com>
	<461D46EF.2040805@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 22:37:03 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> Jiri Slaby napsal(a):
> > Side note, as Danny wrote, there is an asus-laptop driver sitting in -mm,
> > which supersedes this one -- if you plan to push it upstream in the near
> > future, don't bother with this patch.
> 
> Hmm, there is a 0.40 version in -rc6 yet. There is something weird with me
> today.
> 

I don't know what you mean by this.

If your patch is still good then I'd be inclined to proceed with it - yes,
there's a new driver in Len's tree but I assume we'll be maintaining the
old one until the new one is proven to be a successful replacement.

