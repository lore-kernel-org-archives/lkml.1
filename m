Return-Path: <linux-kernel-owner+w=401wt.eu-S1763763AbYEBH5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763763AbYEBH5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 03:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756581AbYEBH5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 03:57:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:31920 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbYEBH5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 03:57:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=pI8EKXAqSFd35mulFSE8r24JONmTHDh99JIzXL9hN/aIxiartIhBs8V688Z8164VF1VjC9X/nPXbb5fi2OsPDMoL2SjS07i8acp5eaWUdAzkFNcljkrgy7tpdA1xOihmB3d5aqQBEqkoGXiWy3IwTD3kyQU98PVkpXlbFgTkGr8=
Message-ID: <481AC957.5000908@gmail.com>
Date: Fri, 02 May 2008 09:57:11 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de, hpa@zytor.com
Subject: Re: [PATCH 1/2] x86_64: fix mm.txt documentation
References: <1209635899-23018-1-git-send-email-jirislaby@gmail.com> <20080502072226.GB713@elte.hu>
In-Reply-To: <20080502072226.GB713@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2008 09:22 AM, Ingo Molnar wrote:
> Mind doing a 
> patch that reinstates it, by lowering the 512 image size limit to 508 
> MB?

Yup, I will.
