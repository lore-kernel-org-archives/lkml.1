Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbZIVMa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbZIVMa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 08:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbZIVMa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 08:30:58 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:52260 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbZIVMa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 08:30:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=JZ09R2BaO6U6jmTipSQ96t3f2qDv39wEkARVXJYU5cvnfOeOjw7sXOguD75Z3Vm1BV
         59RxIMOhQDmGZiNoSz46RF7HiGxCqB/SbcjcjN4Wi23OdAnIZYxauwGxVjKFY80yrChD
         AU7xMJx8Yid5fYFR0g4zWsfN09skdijrUB/aY=
Date: Tue, 22 Sep 2009 14:30:53 +0200
From: Vladimir Botka <vbotka@gmail.com>
To: bluezprofile kernel <bluezprofile@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org
Subject: Re: BlueZ Supported Profiles
Message-ID: <20090922143053.287fc8a5@vlado>
In-Reply-To: <ba5648fa0909212143g36f47acck2e4b610429c477ec@mail.gmail.com>
References: <ba5648fa0909212143g36f47acck2e4b610429c477ec@mail.gmail.com>
Organization: netng.org
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009 10:13:40 +0530
bluezprofile kernel <bluezprofile@gmail.com> wrote:

> Hi,
> I would like to know what are all profiles supported by BlueZ?
> Is there any site gives list of profiles supported by BlueZ?
> I am using BlueZ 4.46.
> 

Hi,
you can see the provided services with the command:
# sdptool browse BTADDR

Get the BTADDR from the output of:
# hcitool scan

Run these command from another Linux box.
HTH,
-- 
	-vlado
	Vladimir Botka

