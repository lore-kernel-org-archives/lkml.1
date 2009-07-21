Return-Path: <linux-kernel-owner+w=401wt.eu-S1752695AbZGUNir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbZGUNir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 09:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZGUNip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 09:38:45 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:34515 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbZGUNio convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 09:38:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mXCG6rO2enD8CO8nkW03HnnQOGClxrTadovlfevma7Y99cEEdEf1fEugKcZ3jWuCbk
         rep9Ni+18tRb3/M8r6Sdo3PRq+eybbO9UeqZHFJ7uFKD4ISpQx1yqnklH2KyyV/fR+8K
         1OVeIC5UKs5Rg2fkQkxzkVI4mVTA8NL2wGU48=
MIME-Version: 1.0
In-Reply-To: <200907211407.40229.arnd@arndb.de>
References: <20090720160025.GA20249@kroah.com>
	 <871vob4047.fsf@basil.nowhere.org> <20090720195754.GB30483@suse.de>
	 <200907211407.40229.arnd@arndb.de>
Date: Tue, 21 Jul 2009 15:38:43 +0200
Message-ID: <e7c6a05e0907210638g188c9eabie656d5c3fb1365b9@mail.gmail.com>
Subject: Re: [patch 00/54] [Announce] Microsoft Hyper-V drivers for Linux
From: Belisko Marek <marek.belisko@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: virtualization@lists.linux-foundation.org, devel@driverdev.osuosl.org,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, Andi Kleen <andi@firstfloor.org>,
       Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 2:07 PM, Arnd Bergmann<arnd@arndb.de> wrote:
> On Monday 20 July 2009, Greg KH wrote:
>> Anyway, I agree, for a "proper" review, I will show the final, cleaned
>> up version, like normal.  But we aren't there just yet, that is why this
>> code is going to live in the staging tree for a while.  Give us some
>> time to get it fixed up.
>
> I would find it helpful to have them in a git tree (or a branch) that
> I can pull, so I can look at both the original code and the cleaned up
> state.
You can find sources in linux-next tree in /drivers/staging/hv directory.
(git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git)
>
> Any reason why the patches are not yet in your staging.git?
>
>        Arnd <><
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
>

Marek
