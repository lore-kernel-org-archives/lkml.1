Return-Path: <linux-kernel-owner+w=401wt.eu-S932779AbXGZP0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779AbXGZP0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758806AbXGZP0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:26:21 -0400
Received: from hu-out-0506.google.com ([72.14.214.233]:52158 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892AbXGZP0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:26:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=JuaMAX6xOXYfDIb0bwicuayxL9YJnzwxygM1shL4Lk6pH0o/+/92yR/ZnsnMNg2HFNUFSyvRGSePERxw6CgyavVvDGWEdZdkVcm7iVv1Xu7ABoDWPRkjGQCLg8tqrB7c8z2ogWdFBHaZUvsXXYwd5Quok9UUqJEy9YwAe4b63P0=
Date: Thu, 26 Jul 2007 16:26:04 +0100
From: Xudong Guan <xudong.guan@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bbpetkov@yahoo.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1: no setup signature found...
Message-ID: <20070726152604.GA25792@xguan-laptop>
References: <20070724112618.GA4431@gollum.tnic> <20070726150854.GA7034@xguan-laptop> <46A8BB6C.6050903@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A8BB6C.6050903@zytor.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08:19(-0700) Thu 26 Jul, H. Peter Anvin wrote:
> What distro/version of grub are you running?  I'm wondering if there are
> some old version of grub out there which did the "load four sectors"
> way-anciently-obsolete crap; the other possibility that comes to mind is
> setting up the stack in an invalid manner

My grub screen shows "GRUB  version 0.91". I am playing with a qemu
image with this version of grub came from an old Damn Small Linux distribution.

Xudong
