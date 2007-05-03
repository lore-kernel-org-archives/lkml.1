Return-Path: <linux-kernel-owner+w=401wt.eu-S1751674AbXECTv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbXECTv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 15:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbXECTv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 15:51:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:29509 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbXECTvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 15:51:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cpShSrjW5GmDyyZNxxvUV/TUoDLVfbjcFiaYFnJQDNSrGw9hPy80T4cE8Z7wYGf5YhMbNI/id0lBNknkU/l9GPxXTExdwfc8UqljRIVSboEKGfjsBK6XgsbUrsU97ZvsNxybQFaAD+R0p+Lrtypgsin2stvaXOxYG5oHJuyM+QQ=
Message-ID: <6bffcb0e0705031251u4f3c3a5hfdc73913eab48a38@mail.gmail.com>
Date: Thu, 3 May 2007 21:51:52 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Ben Castricum" <mail0704@bencastricum.nl>
Subject: Re: kernel panic with 2.6.21-gdc87c398
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <000701c78db0$2a33d930$0602a8c0@links>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <000701c78db0$2a33d930$0602a8c0@links>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On 03/05/07, Ben Castricum <mail0704@bencastricum.nl> wrote:
>
> Roughly 5 minutes after trying 2.6.21-gdc87c398 it paniced. I took a couple
> of pictures of the screen and rebooted. So far it hasn't happened again.
>
> I uploaded all the info into
>
> http://www.bencastricum.nl/2.6.21-gdc87c398/
>
> Hopefully this helps.
> Ben
>

This is a known bug, here is a patch
http://lkml.org/lkml/2007/5/3/38

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
