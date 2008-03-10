Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbYCJIfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbYCJIfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 04:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYCJIfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 04:35:11 -0400
Received: from mail.netone.net.tr ([193.192.98.182]:36992 "EHLO
	mail.netone.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbYCJIfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 04:35:10 -0400
Message-ID: <47D4F250.5000307@netone.net.tr>
Date: Mon, 10 Mar 2008 10:33:20 +0200
From: Tarkan Erimer <tarkan@netone.net.tr>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux-2.6.25-rc4 (and also in rc3) Compile Error
References: <47CE6F66.7020004@netone.net.tr> <47D0895C.5070901@goop.org> <47D0F9D7.8010607@netone.net.tr> <47D172A2.5000408@goop.org>
In-Reply-To: <47D172A2.5000408@goop.org>
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Mar 2008 08:28:58.0318 (UTC) FILETIME=[C93906E0:01C88288]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> At what point does it fail?  Is it early in the build, or late?  
> What's your build command line?
>
>    J
I use Kubuntu's own kernel build via the command "make-kpkg 
--revision=1  kernel_image kernel_headers". It fails at the very early 
build stage. When issued this command, just after few lines and then it 
fails. Today, I will try the same .config with recently released rc5 and 
will let know the result.
