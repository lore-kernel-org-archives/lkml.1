Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbZALIiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbZALIiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 03:38:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbZALIhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 03:37:45 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:16947 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZALIho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 03:37:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=uMm8pffTMGMDg5V1aVY75CzHsvGCO8t6hGhKI6bSUNEEzle7zCSEg4iIs68X5qhRjR
         Rm+HmuN7On4B9ZFRs4frJFVaoh2ndaLnaweAbjRSOkbmR38QPt7J6+T7dxxjO5iYMdcZ
         3J4Bs1LaO+C3okvPRk68gG+lu6p9He49VEEiI=
Message-ID: <621d098f0901120037y4e17b4bn8d52a8ecdbc3fcff@mail.gmail.com>
Date: Mon, 12 Jan 2009 09:37:42 +0100
From: "Jan Dittmer" <jdi@l4x.org>
To: "Dave Airlie" <airlied@gmail.com>
Subject: Re: intel kms "Failed to allocate space for kernel memory manager"
Cc: "Diego Calleja" <diegocg@gmail.com>, linux-kernel@vger.kernel.org,
       eric.anholt@iintel.com, airlied@linux.ie
In-Reply-To: <21d7e9970901120004t2dd68241x6b9533f489601109@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <621d098f0901110546p2b99a525k5de54e37fa181197@mail.gmail.com>
	 <621d098f0901110551v5a05f69aqc4e06a6905989d6e@mail.gmail.com>
	 <20090111222122.4d0cb146@diego-desktop>
	 <21d7e9970901111339q705bcea4i44941bfd84a075fe@mail.gmail.com>
	 <621d098f0901112342q353326b2k31c276e044ad9d0a@mail.gmail.com>
	 <21d7e9970901120004t2dd68241x6b9533f489601109@mail.gmail.com>
X-Google-Sender-Auth: 67f4f82c99aceef4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 9:04 AM, Dave Airlie <airlied@gmail.com> wrote:
> the latest git should work with kms on most chipsets, we are still
> chasing down some issues on some chipsets,

So is there anything I can test to help you get it going on 'my' chipset
(GM965, Lenovo X300)?

Jan
