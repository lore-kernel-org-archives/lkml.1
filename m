Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbYIOSJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbYIOSJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 14:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbYIOSJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 14:09:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:63230 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbYIOSJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 14:09:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Igcp4faBu/CN7hyCNAJjTuUwAKVtbuMupIsfDIXFHG3zYUdDoyTQZgjLIraC/ibXHF
         gZ8glbuutth6wYdGQNWUIARLcJKzBx3BNIr1iXdhTKSkmSqSmZJ3zrqJE2YYaRB0iPwv
         DhRWCLjDF/ybTdd/b+8DhKsO4Zv4Vh15brsIo=
Message-ID: <41840b750809151109o62111f65w51ca0e7b036ca3a@mail.gmail.com>
Date: Mon, 15 Sep 2008 14:09:39 -0400
From: "Shem Multinymous" <multinymous@gmail.com>
To: "Tejun Heo" <tj@kernel.org>
Subject: Re: Laptop shock detection and harddisk protection
Cc: "Greg KH" <greg@kroah.com>, "Elias Oltmanns" <eo@nebensachen.de>,
       "Thomas Renninger" <trenn@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>
In-Reply-To: <48CE1CE8.502@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48C7FCEE.8060404@kernel.org>
	 <41840b750809110908o54a61f55w7b1b9793abf55634@mail.gmail.com>
	 <48C948A6.3080404@kernel.org>
	 <41840b750809111325t30f8ffe2sa4572d401d43dc5a@mail.gmail.com>
	 <48C9AB5A.705@kernel.org> <20080912165947.GB5094@kroah.com>
	 <48CE1CE8.502@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 15, 2008 at 4:29 AM, Tejun Heo <tj@kernel.org> wrote:
>> Sorry, but no, I can't accept this code as it is coming from a "known
>> anonymous" person containing information that it is not known where it
>> came from.
>>
>> We went over this before a number of years ago, that's why this code
>> isn't in mainline :(
>
> Shem Multinymous, I suppose nothing really has changd since the last
> time?

The only pertinent change is that I've added even more documentation
to thinkpad_ec.c, explaining how we're just following the published
H8S specs (plus some workarounds for experimentally observed bugs).

As noted before, I'd be more than happy to assign away copyrights or
discuss things further in private if this would help.

  Shem
