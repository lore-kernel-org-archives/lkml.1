Return-Path: <linux-kernel-owner+w=401wt.eu-S1761894AbYGBEok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761894AbYGBEok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 00:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYGBEoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 00:44:32 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:36570 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbYGBEob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 00:44:31 -0400
Message-ID: <486B076C.6020600@skyrush.com>
Date: Tue, 01 Jul 2008 23:43:24 -0500
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080514)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org,
       free_beer_for_all@yahoo.com, paul@briny.ondioline.org
Subject: Re: [PATCH] UTC timestamp option for FAT filesystems
References: <4861D685.4070308@skyrush.com>	<87od5pqh4o.fsf@basil.nowhere.org>	<4862DB28.3050001@skyrush.com>	<48630286.2050006@skyrush.com>	<87wskck5wi.fsf@devron.myhome.or.jp>	<48639863.808@skyrush.com>	<877iccxnwi.fsf@devron.myhome.or.jp>	<4863B9AF.4080105@skyrush.com>	<87zlp8w4br.fsf@devron.myhome.or.jp>	<4863D037.90504@skyrush.com>	<486476A5.7040801@skyrush.com> <20080701162535.126835f0.akpm@linux-foundation.org>
In-Reply-To: <20080701162535.126835f0.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sounds good!  And yes, you are most certainly right about the chick
magnet effect!  :)

I sent an email to Paul asking for a sign-off (copied here too - not
sure the address is still valid), and Barry is also on the cc list of
this email (he was in the thread, so he will likely reply).

				Thanks, Joe

Andrew Morton wrote:
> On Thu, 26 Jun 2008 23:12:05 -0600
> Joe Peterson <joe@skyrush.com> wrote:
> 
>> (I originally based this patch on one submitted last year by Paul
>> Collins, but I updated it to work with current source and changed
>> variable/option naming.  Ogawa Hirofumi (who maintains these
>> filesystems) and I discussed this patch at length on lkml, and he
>> suggested using the option name in the attached version of the patch.
>> Barry Bouwsma pointed out a good addition to the patch as well.)
> 
> It'd be nice to gather Paul's signed-off-by:.  And to add a Cc to
> Barry.  That way they get a mention in the kernel logs (pure chick
> magnetry!) and they are presumably people who can help review the
> change for us.
> 
> But I don't know their email addresses.
> 
