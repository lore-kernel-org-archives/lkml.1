Return-Path: <linux-kernel-owner+w=401wt.eu-S965655AbXEAIOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965655AbXEAIOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 04:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965632AbXEAIOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 04:14:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:34217 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965655AbXEAIOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 04:14:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=kmq6mWOLsjDmKumHbm0uWMh/tsMs/iuxkn3omnWSmCi5XNbmSCzoFNSaVirO1/dVGpZjoEMiRgChiILigt/2kpboPv28G/tuZRplaQVc7f82nK8OGuAQOkZX6/NIXbz0Vq1AW674JrGXNNnO4uDOI3uzmY76+1KaToPZSWZoUVI=
Message-ID: <4636F6F7.9090203@gmail.com>
Date: Tue, 01 May 2007 10:14:47 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@insightbb.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.22 -mm merge plans (RE: input)
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <200704302230.50507.dtor@insightbb.com>
In-Reply-To: <200704302230.50507.dtor@insightbb.com>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov napsal(a):
> On Monday 30 April 2007 19:20, Andrew Morton wrote:
>>  input-ff-add-ff_raw-effect.patch
>>  input-phantom-add-a-new-driver.patch
>>
> 
> It looks like Phanotom will not be using input layer...

Yes, I have a new version, planning to test it tomorrow when I reach the device
and then post it.

You don't want it in input/misc in that case, right? If yes, Andrew, please drop
both.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
