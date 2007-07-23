Return-Path: <linux-kernel-owner+w=401wt.eu-S933990AbXGWDCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933990AbXGWDCA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 23:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759777AbXGWDBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 23:01:51 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:44446 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530AbXGWDBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 23:01:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=axbFgZplER9ZchacEOhqIodaSHz/oXIMf1ajT/FhnGx07NA1jqOzt2/r1SDwlRZ8OcbtNngBPgAjP61VLy2Y8mT6GyDLbk4oN8UhzLapTbiDCgPpv3IBO4LEQXMwDSzTXBLUAbRr/49VUuLGn21dpGqWQGNAiZpnIV1xk9f17Mg=
Message-ID: <a9e22dff0707222001o324e56c1p42f6c63d0778a8c5@mail.gmail.com>
Date: Mon, 23 Jul 2007 06:01:49 +0300
From: "Ni@m" <niam.niam@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: sound is interrupting with new kernels
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <6bffcb0e0707221716k67815a2ai7f35606b1effa6a3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a9e22dff0707211510o3b5e108dk354f5f15ad3ba498@mail.gmail.com>
	 <6bffcb0e0707221716k67815a2ai7f35606b1effa6a3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>Please run this script while using mplayer or audacious
>http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

No need. I'm testing now pure 2.6.22:
my uname is 'Linux niam 2.6.22 #2 Sun Jul 22 13:52:03 EEST 2007 i686
Intel(R) Celeron(R) M processor 1.50GHz GenuineIntel GNU/Linux' and I
have described problems with mplayer, but they are not so hard: sound
is interrupting for much less time! Usually this case occurs after
pause in watching the movie ... for the first time sound is
interrupting and then normal flow is restoring.

I'll try 2.6.20 later and I'll send a report!

Best wishes!
