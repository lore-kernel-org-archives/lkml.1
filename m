Return-Path: <linux-kernel-owner+w=401wt.eu-S1758288AbYCGIRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbYCGIRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 03:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbYCGIRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 03:17:14 -0500
Received: from mail.netone.net.tr ([193.192.98.182]:36775 "EHLO
	mail.netone.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbYCGIRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 03:17:13 -0500
Message-ID: <47D0F9D7.8010607@netone.net.tr>
Date: Fri, 07 Mar 2008 10:16:23 +0200
From: Tarkan Erimer <tarkan@netone.net.tr>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux-2.6.25-rc4 (and also in rc3) Compile Error
References: <47CE6F66.7020004@netone.net.tr> <47D0895C.5070901@goop.org>
In-Reply-To: <47D0895C.5070901@goop.org>
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2008 08:11:10.0399 (UTC) FILETIME=[CD7444F0:01C8802A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>
> That doesn't make much sense.  Are you compiling with ARCH=xen or 
> something?  I can't reproduce it here with your .config.
>
>    J

Nope, I just selected the  "Processor type and features -> 
Paravirtualized guest support" ( PARAVIRT_GUEST [=y] ) and all the sub 
selections under this feature. When I compiled PARAVIRT_GUEST=n, it 
compiles without any problem.
