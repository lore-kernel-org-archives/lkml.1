Return-Path: <linux-kernel-owner+w=401wt.eu-S1762877AbYESTVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762877AbYESTVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 15:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762550AbYESTU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 15:20:57 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:60907 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762465AbYESTU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 15:20:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=QCwTmSO2rMA/IZlWgX0JP23jnHJXEj4qDFLicx64NIggXg5elrijRZluTALGwgFbGhp5zjRwsNpYzCpB1BlGi3kcyJUgPl/yoDTjrh0jwXS6z9a4TXv3X8e55wdVyGZXuBaEn664YC9gV3RhpYeKjFw9VqlW4Pu5FOjhCNI+HHU=
Message-ID: <4831D2F3.6020506@gmail.com>
Date: Mon, 19 May 2008 21:20:19 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] i2c: align i2c_device_id
References: <1211203124-3096-1-git-send-email-jirislaby@gmail.com> <20080519210003.65b65d14@hyperion.delvare>
In-Reply-To: <20080519210003.65b65d14@hyperion.delvare>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2008 09:00 PM, Jean Delvare wrote:
> Hi Jiri,

Hi.

> Thanks for this patch, it's in my i2c tree now and will be sent to
> Linus by the end of the week. I wasn't aware of this possible alignment
> issue, sorry.

To be honest, neither I was until I hit it while testing hid bus (where I did 
the same mistake). Thanks.
