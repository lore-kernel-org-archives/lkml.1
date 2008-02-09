Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbYBIVYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbYBIVYG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 16:24:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755551AbYBIVXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 16:23:53 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:49268 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553AbYBIVXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 16:23:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=SYt8ino7Z+hdEtB8hKsH6c5v0mk8kmAw3VrInLCOJ2QnhxNbulgmTX5N9OWoyTlMTg2M1xz7iMPqp992LLVas2IorA2ptZpM4pEtrshtO3/9E5QlRgQTSl6XyaumjZKJbTJpqjRPk+pTJkyawwIbWk8Eos8Az0ObtOyJf0k0AzM=
Message-ID: <47AE19E4.8040809@gmail.com>
Date: Sat, 09 Feb 2008 22:23:48 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: digi driver removable?
References: <alpine.LFD.1.00.0802091132170.5784@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.00.0802091132170.5784@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2008 05:39 PM, Robert P. J. Day wrote:
>   from a discussion once upon a time, it isn't clear whether or not
> this (and everything that goes with it) is deletable:
> Documentation/digiepca.txt.

http://lkml.org/lkml/2006/10/26/231

Maybe the time has come. If I was you I would create a patch to see if somebody 
will complain at all...
