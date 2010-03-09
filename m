Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab0CILi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 06:38:57 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61626 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab0CILix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 06:38:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cz9PbNMqhWuxy4uASGgq2bPwE9Tw7S7X5Ylp83s/pAfwfB7HK/RxuwtgxGVOIWD/EY
         EXe3nEjhUY0T92Eiqace2CyPjJPb5wIX+jvw7cw+JL6V7fZn/A58hC6euZVQ4Qp6/V51
         Z/dII5LWzc6Zuwj4b9KaqjsNE8mlsjutGppoo=
MIME-Version: 1.0
In-Reply-To: <201003091234.59598.rjw@sisk.pl>
References: <201003062236.09801.rjw@sisk.pl>
	 <68676e01003090301s5bb40d4hac1224a9658339ac@mail.gmail.com>
	 <201003091234.59598.rjw@sisk.pl>
Date: Tue, 9 Mar 2010 12:38:50 +0100
Message-ID: <b170af451003090338o69225e3ye6beb4b304dcdc8c@mail.gmail.com>
Subject: Re: [Q] How to tell we're using the KMS (during suspend/resume) 
	outside the graphics driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Luca Tettamanti <kronos.it@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/9 Rafael J. Wysocki <rjw@sisk.pl>:
> On Tuesday 09 March 2010, Luca Tettamanti wrote:
>> I'm note sure how to check that a device is graphic card though :|
>
> Well, that's the "outside of the graphics driver" part of my question. :-)

Can we use the same way userspace (DDX) uses to check for KMS? Some
IOCTL I guess?

-- 
Rafał
