Return-Path: <linux-kernel-owner+w=401wt.eu-S1761256AbYEXSHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761256AbYEXSHQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 14:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759627AbYEXSHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 14:07:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:6953 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759604AbYEXSHD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 14:07:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=G9P8Gfz96LdOYsTxkEPdtGXWrpPNuE/Lch8Qmc0GBde1els2uUGyZF8aftVhNu9//uE9/IwyniGYQatmayrfJecI0LV+vazhI/NLf1qoAkNz+4F+E5czsSllP3gKLxQ5RtxSNkGY9ndliHxrtQBihqR6bPpVgJoRqEeQdxcWk1U=
Date: Sat, 24 May 2008 20:07:10 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Only print "Decompressing Linux" etc when 'noisy'
 is passed.
Message-Id: <20080524200710.a2400cf4.diegocg@gmail.com>
In-Reply-To: <18487.57106.644612.157155@harpo.it.uu.se>
References: <1211579968-15227-1-git-send-email-krh@redhat.com>
	<1211579968-15227-2-git-send-email-krh@redhat.com>
	<18487.57106.644612.157155@harpo.it.uu.se>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Sat, 24 May 2008 11:25:38 +0200, Mikael Pettersson <mikpe@it.uu.se> escribió:

> All this accomplishes is to make early boot failures harder
> to debug.

And there's already a parameter to switch the verbosity of printk - 'quiet'
