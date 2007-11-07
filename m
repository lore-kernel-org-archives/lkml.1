Return-Path: <linux-kernel-owner+w=401wt.eu-S1757481AbXKGTxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbXKGTxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 14:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbXKGTxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 14:53:37 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:39528 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbXKGTxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 14:53:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=PzkRgWObg7vPwRTQNQoLM91Zt/Zq6hgDug1gloCsbD+XGIxcWkFb9FI2SLug0BjGAaaiN6eCQl/HBn9We1SKZMhUdXW1fahhFSvvCmKfqVIPLwwkPhe13I7voteu/T8VeEBL8D9szcqWH9dx5zO2pu2O7j6wF1ts1U1CgRPledc=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Paul Albrecht <albrecht@rdi1.com>
Subject: Re: unionfs and sys_readahead
Date: Wed, 7 Nov 2007 19:53:25 +0000
User-Agent: KMail/1.9.1
Cc: LKML <linux-kernel@vger.kernel.org>
References: <1194386482.7489.5.camel@albrecht.rdi1.com>
In-Reply-To: <1194386482.7489.5.camel@albrecht.rdi1.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711071953.25716.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 November 2007 22:01, Paul Albrecht wrote:
> Hi,
> 
> Whenever I use readahead-list on a union mounted file system I get a
> segfault and kernel oops so I'm wondering whether or not the linux
> unionfs supports sys_readahead.
> 
> Anyone know? I'm not usually subscribed to the lkml so please cc me in
> your response. Thanks.

Please show actual oops output.

Also: what kernel version do you use? any extra patch(es) applied? .config?
--
vda
