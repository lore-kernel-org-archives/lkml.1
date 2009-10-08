Return-Path: <linux-kernel-owner+w=401wt.eu-S932223AbZJHNb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223AbZJHNb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 09:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932136AbZJHNbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 09:31:55 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:63326 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132AbZJHNbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 09:31:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fjimHkjtQ1JGQzmVU8kXvpnB89R8oRLLW7YUz87u3xr2lV7CI1B27Qvv0Zg72KKpRh
         J+fKNnEBIEnfMw5jMa7ZshdYFGBbkg8e34E/GlIHX80YDFFCtfDfIyRDeeymVXMobJQp
         fHVjpkwQGL1G1k+1IqRWGXhAnzejiqsuodbeM=
Message-ID: <4ACDE9AF.8040001@gmail.com>
Date: Thu, 08 Oct 2009 15:31:27 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-2.1 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, strakh@ispras.ru
Subject: Re: [PATCH 2/4] isicom: switch to the new tty_port_open helper
References: <20091007144455.14550.95003.stgit@localhost.localdomain>	<20091007144621.14550.62068.stgit@localhost.localdomain>	<4ACCF5D5.7010505@gmail.com> <20091008141353.342fd2ae@lxorguk.ukuu.org.uk>
In-Reply-To: <20091008141353.342fd2ae@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2009 03:13 PM, Alan Cox wrote:
> Ok fixed that the simple way the buffer allocator now has its own private
> mutex. Any other problems strike you ?

I don't see any. It looks good. Thanks.
