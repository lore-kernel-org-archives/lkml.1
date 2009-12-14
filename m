Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbZLNE0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbZLNE0Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 23:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbZLNE0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 23:26:21 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:59452 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbZLNE0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 23:26:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UQW0fAXry3L2BnGJg1mToKfzQ+H0Hc7nLLLfoCfr72nC/XXqOAWUkr/0eXcov7L0s/
         DH+4xWvcDx0luzu8/9pUbnN9MxEXlmNcqAjvjwJqZYdJ2GzAVfTBZsxCCjOkRiMnkazX
         6l1F0F4kSVRn21L6hsze5zfTuUq+841+00MGU=
MIME-Version: 1.0
In-Reply-To: <20091213.202037.229738549.davem@davemloft.net>
References: <20091205.193505.193701079.davem@davemloft.net>
	 <d45a3acc0912132017o327f0cd6h8613758fdd050ac3@mail.gmail.com>
	 <20091213.202037.229738549.davem@davemloft.net>
Date: Mon, 14 Dec 2009 15:26:18 +1100
Message-ID: <d45a3acc0912132026w5ab6b3b3x3f211566779257d3@mail.gmail.com>
Subject: Re: [GIT]: Networking
From: andrew hendry <andrew.hendry@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, I didn't know X.25 was actively maintained. I get bounces.
Is the the maintainers out of date?

AX.25 NETWORK LAYER
M:      Ralf Baechle <ralf@linux-mips.org>

X.25 NETWORK LAYER
M:      Henner Eisen <eis@baty.hanse.de>


On Mon, Dec 14, 2009 at 3:20 PM, David Miller <davem@davemloft.net> wrote:
> From: andrew hendry <andrew.hendry@gmail.com>
> Date: Mon, 14 Dec 2009 15:17:19 +1100
>
>> Hi Dave,
>>
>> There were some other X.25 patches you took into net-next last month.
>> X25: Fix oops and refcnt problems from x25_dev_get
>> X25: Check for errors in x25_init
>> X25: Move SYSCTL ifdefs into header
>>
>> But they didn't make it into the pull. If they need some work please
>> let me know.
>
> I'm waiting for Ralf, the maintainer, to review your changes.
>
