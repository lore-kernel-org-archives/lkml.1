Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbYKGFv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbYKGFv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 00:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755788AbYKGFqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 00:46:21 -0500
Received: from rn-out-0910.google.com ([64.233.170.186]:49547 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765AbYKGFqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 00:46:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hS6/nQK5Wvh+y17e7nFNqTVq5U2cSIyyGApm4AwIdDJrW1zmQEik/ztm950/x4DMIi
         d4pCgPj55G4ZZOpGqWuhSnroFqV+aWh4TTVSlt0E1HUv53S3OjoCB7JELp7YpzfNRQNK
         msAk7EaeBUhYnvlW4w1Dx75Mx8CWvo5F1qNyQ=
Message-ID: <8d6898730811062146w45418fcbta659254642906f11@mail.gmail.com>
Date: Fri, 7 Nov 2008 11:16:17 +0530
From: "Nobin Mathew" <nobin.mathew@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: sharing interrupt between PCI device
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       "Robert Hancock" <hancockr@shaw.ca>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <4913609F.7050607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.h7+lofM1lpbRM5V4/ti5d7RwXuM@ifi.uio.no>
	 <4910E8AC.7050407@shaw.ca>
	 <8d6898730811042349p19e65556l8e1c851b27758d5@mail.gmail.com>
	 <49115AFC.2030400@gmail.com>
	 <8d6898730811050120k10a20e4em744be45e04cfba94@mail.gmail.com>
	 <8d6898730811052211k695d208r53609701af633c2d@mail.gmail.com>
	 <8d6898730811052344q218fc450i8c36fcd9e119d060@mail.gmail.com>
	 <4913609F.7050607@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exactly

On Fri, Nov 7, 2008 at 2:54 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 11/06/2008 08:44 AM, Nobin Mathew wrote:
>> Hi
>>
>> can anybody point to some reference device drivers where PCI interrupt
>> sharing is implemented properly.
>
> Sorry, I still don't understand the setup. You have two separate pci devices,
> both with the same irq number and pci_disable_device on one of them stops irqs
> on the second?
>
