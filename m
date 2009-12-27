Return-Path: <linux-kernel-owner+w=401wt.eu-S1752343AbZL0Nua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbZL0Nua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 08:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbZL0Nu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 08:50:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbZL0Nu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 08:50:27 -0500
Message-ID: <4B376604.4060808@redhat.com>
Date: Sun, 27 Dec 2009 15:49:56 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, kvm@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, netdev@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Alacrityvm-devel] [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <87637zdy9g.fsf@basil.nowhere.org>	 <4B30E654.40702@codemonkey.ws> <200912221701.56840.bzolnier@gmail.com>	 <4B30F214.80206@codemonkey.ws> <20091223065129.GA19600@elte.hu>	 <20091223101340.GC20539@basil.fritz.box> <4B31EF65.6070000@redhat.com>	 <4B325E33.8060407@gmail.com> <4B327B90.2050403@redhat.com> <b233dd490912231321p5e09946at5ea63cb0d0fa1489@mail.gmail.com> <4B3725CE.8040004@redhat.com> <4B375EAD.8050204@gmail.com> <4B3760D2.3080500@redhat.com> <4B376391.40706@gmail.com>
In-Reply-To: <4B376391.40706@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2009 03:39 PM, Gregory Haskins wrote:
> No, where we are is at the point where we demonstrate that your original
> statement that I did nothing to improve virtio was wrong.
>
>    

I stand by it.  virtio + your patch does nothing without a ton more work 
(more or less equivalent to vhost-net).

-- 
error compiling committee.c: too many arguments to function

