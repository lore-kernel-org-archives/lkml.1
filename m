Return-Path: <linux-kernel-owner+w=401wt.eu-S1758381AbZEEJge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381AbZEEJge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 05:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbZEEJgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 05:36:25 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:16082 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbZEEJgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 05:36:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=cELP+K9KHDu0i16QpoD8TNKElC9+srY3xfljVtVMFkLECZY2TjR6cc0Ra1Kgm4F3Gy
         cqB3ivSdaxRj8/UMqnhYmLoojueUc0TE2ziGOnYZhejw7AesSDb3v2IZTcEYU/SCVQn1
         KVoHzrf32bhLU/DWJjuy5KPw4SVNbzQ84YPVY=
Message-ID: <4A000891.3070109@gmail.com>
Date: Tue, 05 May 2009 11:36:17 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.7 Thunderbird/3.0b2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>, shaohua.li@intel.com,
       arjan@infradead.org, James.Bottomley@HansenPartnership.com
Subject: kexec defunct -- sd-async-shutdown [mmotm 2009-04-30-17-55]
References: <200905010114.n411EV3X022247@imap1.linux-foundation.org>
In-Reply-To: <200905010114.n411EV3X022247@imap1.linux-foundation.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2009 02:55 AM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-04-30-17-55 has been uploaded to
...
> sd-async-shutdown.patch

Hi,

this one causes kexec to hang.
