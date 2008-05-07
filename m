Return-Path: <linux-kernel-owner+w=401wt.eu-S1760476AbYEGSZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476AbYEGSZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbYEGSZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:25:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:56842 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758189AbYEGSZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:25:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hZGVIHuDo11Q7yheP/Aj0kqlbHlTWjhk+gKkWl97rqwJpyQuFmTLMWRv/VZcpgOQrGjT77N5P9emoe2y7zeCYkvz8TH4a43FlKraT9NICILuFcdsNy7Iz4ky0gJvOEwqlNhyF6QmT0Je75p8VmM++b2qLI/XHfs0gH+UBmF6VlQ=
Message-ID: <4821F3EE.1010309@gmail.com>
Date: Wed, 07 May 2008 20:24:46 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: nopage to fault
References: <dd18b0c30805071040i5e9c3d73uf60235b94dcce3c5@mail.gmail.com>
In-Reply-To: <dd18b0c30805071040i5e9c3d73uf60235b94dcce3c5@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2008 07:40 PM, Justin Mattock wrote:
> of the areas that I'm lost with is NOPAGE_SIGBUS for a return value.
> in mm.h The only options I see is VM_FAULT_SIGBUS, VM_FAULT_ERROR. If

The former, next time, google little bit, please.
