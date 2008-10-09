Return-Path: <linux-kernel-owner+w=401wt.eu-S1757086AbYJIVvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbYJIVvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 17:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755856AbYJIVve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 17:51:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:16847 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683AbYJIVvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 17:51:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=qkwOX3p0FTIF7hAKPnf0fypsLni7Ky7BvRRUuwxQHfujMoS/heTLsG907kqDrRzghG
         pIu5kS5veVdrWf7CnAwGFOXBfR+3uwt/7oWLuRPClZv4xU9/EJLYyvwzjiDfuq4Xa7Cp
         9z7ZFBfmopUhUFkHXnO+aaVhFD8U0K877xyK4=
Message-ID: <86802c440810091451y4a3caceg1abaa75464c40a72@mail.gmail.com>
Date: Thu, 9 Oct 2008 14:51:32 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: [PATCH] pci: print out DMA mask info
Cc: "Grant Grundler" <grundler@parisc-linux.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20081009213551.GC25780@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223506943-6543-1-git-send-email-yinghai@kernel.org>
	 <20081009211837.GC18444@colo.lackof.org> <48EE7745.2020603@kernel.org>
	 <20081009213551.GC25780@parisc-linux.org>
X-Google-Sender-Auth: d47d26e604cac72c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2008 at 2:35 PM, Matthew Wilcox <matthew@wil.cx> wrote:

>
> Why's that interesting to the sysadmin of the machine?  To the driver
> writer, certainly.  But what's the use of it to the people using the
> machine?
>
> --
> Matthew Wilcox                          Intel Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."

make linux kernel act like black box as other os?

YH
