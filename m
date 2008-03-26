Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbYCZIZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbYCZIZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 04:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYCZIZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 04:25:16 -0400
Received: from mail.netone.net.tr ([193.192.98.182]:15325 "EHLO
	mail.netone.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbYCZIZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 04:25:15 -0400
Message-ID: <47EA0869.8090004@netone.net.tr>
Date: Wed, 26 Mar 2008 10:25:13 +0200
From: Tarkan Erimer <tarkan@netone.net.tr>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux-2.6.25-rc4 (and also in rc3) Compile Error
References: <47CE6F66.7020004@netone.net.tr> <47D0895C.5070901@goop.org> <47D0F9D7.8010607@netone.net.tr> <47D172A2.5000408@goop.org> <47D4F250.5000307@netone.net.tr> <47D52B79.7030009@netone.net.tr> <47DE3227.2030802@netone.net.tr> <47DE7DCF.6090103@goop.org> <47DF771D.6060707@netone.net.tr> <47DFDB39.8070800@goop.org>
In-Reply-To: <47DFDB39.8070800@goop.org>
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2008 08:23:20.0300 (UTC) FILETIME=[A65B92C0:01C88F1A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> I'm guessing that make-kpkg is looking at the .config and when it sees 
> CONFIG_XEN=y it does something assuming the old out-of-tree Xen 
> patches.  Suse's kernel package builder had a similar problem.

Hmm..... It seems, these distro kernel builders need to be updated to 
compile newest kernels correctly.
