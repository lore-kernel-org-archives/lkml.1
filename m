Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbYGQEES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbYGQEES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 00:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750784AbYGQEEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 00:04:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:8719 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbYGQEEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 00:04:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TDcXA1sl7z+BXF9w7WnCnO7RMZJEcEQla2iv570ER53ViXuB4ggTwM7QrFQBLdMwN7
         KQ9pMeahEJIkUsP0pBXHmqJhLskIM/Ennr23yCkDWoJ7bl0H8zLtMEHu8tOSaNAfQb22
         CAzAJfuaCFFptYhWWM9HKW0Ajv6+2PigW+PLY=
Message-ID: <86802c440807162104x4a6a377dl129604f31193a212@mail.gmail.com>
Date: Wed, 16 Jul 2008 21:04:07 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20080717031502.GA18760@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440807160044ge504cacl419b6cbcad5f0f9d@mail.gmail.com>
	 <86802c440807160136m6af981b2u6a37cabb8e33a629@mail.gmail.com>
	 <20080716140810.GA2861@bromo.msbb.uc.edu>
	 <86802c440807161029n7e0dac98x1ec260879204b6f0@mail.gmail.com>
	 <86802c440807161535n3a4d6891n6f7c16bd4e1f19c3@mail.gmail.com>
	 <20080717004004.GA17792@bromo.msbb.uc.edu>
	 <86802c440807161749u2f5c1eben618e05c6e254fedd@mail.gmail.com>
	 <20080717023538.GA18329@bromo.msbb.uc.edu>
	 <86802c440807161959s10666027k5297af1d657ff4fa@mail.gmail.com>
	 <20080717031502.GA18760@bromo.msbb.uc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 8:15 PM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
> YH,
>   I meant that pci=nommconf doesn't allow the boot to complete
> under 2.6.26. I haven't tried that under 2.6.25.10, however the
> 2.6.5.10 kernel should be using mmconfig since I see...
>
> PCI: Using MMCONFIG at f0000000 - ffffffff
> PCI: Using configuration type 1 ===========> it fallback to use conf1 for access

YH
