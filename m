Return-Path: <linux-kernel-owner+w=401wt.eu-S1752683AbYCRIFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbYCRIFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 04:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYCRIFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 04:05:24 -0400
Received: from mail.netone.net.tr ([193.192.98.182]:26708 "EHLO
	mail.netone.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbYCRIFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 04:05:23 -0400
Message-ID: <47DF771D.6060707@netone.net.tr>
Date: Tue, 18 Mar 2008 10:02:37 +0200
From: Tarkan Erimer <tarkan@netone.net.tr>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux-2.6.25-rc4 (and also in rc3) Compile Error
References: <47CE6F66.7020004@netone.net.tr> <47D0895C.5070901@goop.org> <47D0F9D7.8010607@netone.net.tr> <47D172A2.5000408@goop.org> <47D4F250.5000307@netone.net.tr> <47D52B79.7030009@netone.net.tr> <47DE3227.2030802@netone.net.tr> <47DE7DCF.6090103@goop.org>
In-Reply-To: <47DE7DCF.6090103@goop.org>
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Mar 2008 08:03:32.0797 (UTC) FILETIME=[8F3EFED0:01C888CE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> What's the command you're using to build?  What happens if you build 
> the kernel normally?
>
>    J

Normally I use the ubuntu's kernel build commands : make-kpkg 
--revision=1  kernel_image kernel_headers

When I tried with "make bzImage" "make modules", everything went very 
smooth and it compiled successfully. It seems, some virtualization 
changes effected the ubuntu's kernel build process. Thank you very much 
for your help and pointing it, Jeremy.
