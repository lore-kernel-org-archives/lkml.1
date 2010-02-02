Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab0BBPUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:20:14 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:48583 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab0BBPUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:20:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=jRep7yGJuC8oC2M/ZYdLhhuH5L6SCjxio0PupT5OlrQSlfVYaB59Cr39gMUKWx79mf
         tSk5IFntN4YEm9Q0m8scSbIOOINb1x67Tp6uhJPB4NHD2OlaQBSgBUQouwvAOGC3vMN8
         UmshJqeQficOIdEhSjFucjqzNFxySiCEeUA90=
MIME-Version: 1.0
In-Reply-To: <f124e3b71002020716u5ee3cec7tbe35e07d70367948@mail.gmail.com>
References: <Xns9D138D644D73mpiazzafastwebnetit@213.140.2.16>
	 <20100202130002.68E043A6641@erode.bofh.it>
	 <f124e3b71002020716u5ee3cec7tbe35e07d70367948@mail.gmail.com>
Date: Tue, 2 Feb 2010 16:20:07 +0100
Message-ID: <f124e3b71002020720x98f7fedg1ad1aba4a1087494@mail.gmail.com>
Subject: Re: Phoronix test
From: Marco <mpiazza@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What commit is responsible for the boost in IO thread tester shown on
phoronix (at 31/01/2010)?
http://www.phoromatic.com/kernel-tracker.php

And is really ext4 so unreliable as they say in here?:
http://www.phoronix.com/scan.php?page=news_item&px=Nzk0OA

It happens also to me using git master: several times my GPU goes wild
(i915) and the only thing to do is press the halt button. And ext4
sometimes looses data, without doing a fsck at restart.
Is there a way to know something went wrong, even if fsck did not say anything?

Bye
Marco
