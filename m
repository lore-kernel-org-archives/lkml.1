Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbZF0HV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbZF0HV7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 03:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbZF0HVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 03:21:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:19067 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbZF0HVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 03:21:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OocQBIz+eOsX6FwLWiwUF32arPFz/rUU1VxIohIeCOliYQBWos89Ok9r3dFTzmIt2T
         IchtNaq5GZJkzUq4XWSzB0WkOOxTJnkY7g545BG+yPVnX9VYMk+MUOJPhNx/5pp6sMf/
         3+pDX5AD1hPNrRSJLkmkUSWOcCJrLV94vx1LE=
Message-ID: <4A45C707.5010503@gmail.com>
Date: Sat, 27 Jun 2009 10:15:19 +0300
From: Aioanei Rares <krnl.list@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: James Dolan <jamesdolan@clear.net.nz>
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel testing in a VM good idea?
References: <20090627185749.065bcab4@linux-uvcl.site>
In-Reply-To: <20090627185749.065bcab4@linux-uvcl.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Dolan wrote:
> Are there any disadvantages to testing/developing a kernel in a VM ? (i
> luck the availability of hardware) 
>   
I personally prefer to find a spare machine to do testing/compiling 
rather  than a VM. Maybe the most experimented users of this list will 
give you technically-oriented reasons.
