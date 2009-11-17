Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbZKQSGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbZKQSGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 13:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbZKQSGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 13:06:30 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:48343 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700AbZKQSG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 13:06:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Epnf4zJlsu5BL14bxwH1ysWPonoweSkQMPrwq4IedZkSAJWydbfecsDHz3xaZQiKWW
         Boui0RJ6x2dIgRiSR4KL5+RRNPljvjygT9Yo7R7Vawh2nbMzA1whC532sRfXDYRaTgXd
         BZFHNIWBSQcNyy8tXE2b1IKiUGLfntE3hbiKA=
Message-ID: <4B02E64D.2010700@gmail.com>
Date: Tue, 17 Nov 2009 10:07:09 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Bug #14267] Disassociating atheros wlan
References: <ipicVA1QUFF.A.zWB.1mdALB@chimera>	<OWmO9uyC1hM.A.yiC._ndALB@chimera>	<4B01F3FE.8040707@gmail.com> <20091117113320.8aef894a.kristoffer.ericson@gmail.com>
In-Reply-To: <20091117113320.8aef894a.kristoffer.ericson@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristoffer Ericson wrote:
>
>
> Im still hitting this so basicly using 2.6.30 until it get sorted. Will try and make
> some time to test the different commits. Last time I waited for it to disconnect which
> could take 10-40min. Since it depends on the network load Im now going to increase
> the load to see if I hit it quicker (and thus finding the error commit).
>
> So in short, its still valid and I will try and make time to fix it :)
>
>
>
>    
o.k. so it is something that is enough to
cause an inconvenience.

Justin P. mattock
