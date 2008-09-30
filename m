Return-Path: <linux-kernel-owner+w=401wt.eu-S1753775AbYI3TXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbYI3TXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 15:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYI3TXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 15:23:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:4526 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbYI3TXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 15:23:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tEZEplF9mLoShbWzuN9tVrPKd6gnEE2cSlzD6kKodfk/bu0CBc6eph4nWXuMHQeBgE
         dtX6LfFMobRyLmLlWYjzp7qlURdwmGg5oX2n6sqKmv6B0UbGSCKwXUmC/MsjBDJ/iGiQ
         oKiK9W03mafsjOj/kxXnMKHTfxaGspLJzD2uM=
Message-ID: <f4527be0809301223h32da7f3aifc0850597f9ff3e2@mail.gmail.com>
Date: Tue, 30 Sep 2008 20:23:42 +0100
From: "Andrew Lyon" <andrew.lyon@gmail.com>
To: "Rabin Vincent" <rabin@rab.in>
Subject: Re: kernel.org missing .1 incremental patches
Cc: "Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080930191710.GA2477@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f4527be0809301151k66277093gd5303e73df6d834e@mail.gmail.com>
	 <20080930191710.GA2477@debian>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 8:17 PM, Rabin Vincent <rabin@rab.in> wrote:
> On Tue, Sep 30, 2008 at 07:51:00PM +0100, Andrew Lyon wrote:
>> The incremental patches at
>> http://www.kernel.org/pub/linux/kernel/v2.6/incr/ seem to be missing
>> all .1 patches, for example there are patches to take 2.6.25 from
>> EXTRAVERSION = .2 to .17 but no patch for .0 > .1, attempting to apply
>> patch-2.6.25.1-2 to 2.6.25 will fail on the Makefile as it does not
>> have the correct starting version.
>>
>> I assume the patches are generated from a script and there is a bug,
>> easily worked around by downloading the full 2.6.25.1 tarball but the
>> full incremental set would be very useful for a project I am working
>> on.
>
> There are no incremental patches for .0 -> .1 in incr because those
> would be the same as the patch-2.6.xy.1.bz2 patches available at
> pub/linux/kernel/v2.6/.
>
> Rabin
>

Sorry, I should really have figured that out!

Andy
