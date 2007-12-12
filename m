Return-Path: <linux-kernel-owner+w=401wt.eu-S1759680AbXLLTI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680AbXLLTI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755723AbXLLTIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:08:21 -0500
Received: from hu-out-0506.google.com ([72.14.214.232]:30428 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbXLLTIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:08:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=mcyVW3phyw6kqz6IMjs4MXjOrlAf9SN1axt/tawBlfwZfAEGKbzETvbXtv6cwZfgZS5rYUE1LAGhVbaw6BSztdgHQg47ti54r1FcWUvARyo8FaAibyFTIvtB3GN1Ch5HuTEOszae2X45ranuOzutTDj03Kvge2Tu7WRQpK7b7tA=
Message-ID: <4760314B.4040109@keyaccess.nl>
Date: Wed, 12 Dec 2007 20:06:51 +0100
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: SL Baur <steve@xemacs.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl> <ed10ee420712121039j79af0eq7b5a994215044199@mail.gmail.com>
In-Reply-To: <ed10ee420712121039j79af0eq7b5a994215044199@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
From: Rene Herman <rene.herman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-12-07 19:39, SL Baur wrote:

> model name      : Intel(R) Pentium(R) 4 CPU 3.20GHz
> cpu MHz         : 3201.345
> 
> cycles: out 3026, in 2204
> cycles: out 3031, in 2182
> cycles: out 3019, in 2196
> cycles: out 3030, in 2201
> cycles: out 3013, in 2186

Thank you. I just posted the combined results, although I see it's not made 
it to the list yet, probably due to a somewhat overly broad CC...

These results fit the pattern.

Rene.
