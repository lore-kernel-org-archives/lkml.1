Return-Path: <linux-kernel-owner+w=401wt.eu-S1757816AbYDAIzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816AbYDAIzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 04:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755890AbYDAIy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 04:54:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:36027 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbYDAIy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 04:54:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=P4HIC5hzxlW28h02xOYD4+KsXEQUO+/knykhd+U6n5UcM1CTDOKt4I0e+jZrDKAhLnM/Z/Ke+n0z02RE3a1dDwDRiKew1TeG0l21foeEjdusH6BJvDagcDsglW5NB4RHF93MP1HHkKctBJD4/dRBHCEVdVsrS1KgXbs8KDWe25M=
Message-ID: <47F1F859.6020305@gmail.com>
Date: Tue, 01 Apr 2008 12:54:49 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] [MIPS] make some functions and variables static
References: <1207001005-2633-1-git-send-email-dmitri.vorobiev@gmail.com> <20080331224143.GA28473@linux-mips.org>
In-Reply-To: <20080331224143.GA28473@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Baechle пишет:
> On Tue, Apr 01, 2008 at 02:03:19AM +0400, Dmitri Vorobiev wrote:
> 
>> I noticed that a few functions and variables in the MIPS-specific
>> code can become static, and this series of patches cleans up the
>> kernel global name space a little bit.
> 
> I've queued the whole series for 2.6.26.

Thank you, Ralf.

Dmitri

> 
> Thanks,
> 
>   Ralf
> 

