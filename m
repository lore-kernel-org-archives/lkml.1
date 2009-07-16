Return-Path: <linux-kernel-owner+w=401wt.eu-S1757162AbZGPCaD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbZGPCaD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 22:30:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757161AbZGPCaC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 22:30:02 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:57888 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157AbZGPCaB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 22:30:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=a5RX6TtyvbbvuGFh02YXbBy+NNKbMQSu5tJpSDBGpz2ohunLbMZIDAu4QUytSc5Y5P
         Kn4AeUMXoNCuyvHSyGpZ5zIvmaqkCRLYuhC25+5EaUjsxjKyBf3esj99Sio8fhrwKQt5
         s0+bJQJy4lyqi89rRfR/t7QIZqK8Lut/yOqbU=
MIME-Version: 1.0
In-Reply-To: <20090716021737.GA30363@kroah.com>
References: <1245763114-7753-1-git-send-email-vapier@gentoo.org> 
	<8bd0f97a0907150908y333f89eav1d0edbb6a5951c05@mail.gmail.com> 
	<20090716021737.GA30363@kroah.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 15 Jul 2009 22:29:40 -0400
Message-ID: <8bd0f97a0907151929t3ca67bc9gd4ebeae1e17894b0@mail.gmail.com>
Subject: Re: [PATCH] USB: isp1760: allow platform devices to customize 
	devflags
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, bigeasy@linuxtronix.de, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 22:17, Greg KH wrote:
> On Wed, Jul 15, 2009 at 12:08:31PM -0400, Mike Frysinger wrote:
>> On Tue, Jun 23, 2009 at 09:18, Mike Frysinger wrote:
>> > From: Michael Hennerich <michael.hennerich@analog.com>
>> >
>> > Platform device support was merged earlier, but support for boards to
>> > customize the devflags aspect of the controller was not.  We want this on
>> > Blackfin systems to control the bus width, but might as well expose all of
>> > the fields while we're at it.
>>
>> ping ...
>
> Ping who, yourself?

ping the guy who can merge the patch ...
-mike
