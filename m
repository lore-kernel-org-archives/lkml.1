Return-Path: <linux-kernel-owner+w=401wt.eu-S1760481AbXJLVIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760481AbXJLVIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 17:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758674AbXJLVIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 17:08:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51445 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757673AbXJLVI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 17:08:28 -0400
Date: Fri, 12 Oct 2007 14:07:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: oops on rmmod asus_acpi
Message-Id: <20071012140754.2643c334.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0710122250290.23981@fbirervta.pbzchgretzou.qr>
References: <20070630022644.20822e6b.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0710122250290.23981@fbirervta.pbzchgretzou.qr>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2007 22:53:08 +0200 (CEST)
Jan Engelhardt <jengelh@computergmbh.de> wrote:

> Hi,
> 
> 
> I am wondering about asus_acpi-fix-oops-on-non-asus-machines.patch ,
> which is still neither in mainline git nor in Len's acpi git tree
> ( http://lkml.org/lkml/2007/6/30/29 ).
> Any plans?
> 

That patch is in 2.6.23.
