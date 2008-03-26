Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbYCZQPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbYCZQPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbYCZQPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:15:12 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:61477 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555AbYCZQPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:15:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=MqsX66Jikbzmu/q5Cf+qnfYi7CswUw8tTXvEldRYNuO0N/Bx7sMgNLOd4+sGro1s0CSD0ulR6ABXijak1/G8SHH2mqD+NC4MeAtbVGKyLcZoEEuCfAGcVg8BZxgKZ6Fer/lbaEaDBHghgnwdATtN8sQhi5S+uV1NNodPuzxJxow=
Message-ID: <386072610803260915j7e4ca889ud193457367c712d3@mail.gmail.com>
Date: Thu, 27 Mar 2008 00:15:07 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/1] Input/Joystick Driver: add support AD7142 joystick driver
Cc: dmitry.torokhov@gmail.com, khali@linux-fr.org, linux-input@vger.kernel.org,
       i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       "Michael Hennerich" <michael.hennerich@analog.com>,
       "Bryan Wu" <bryan.wu@analog.com>
In-Reply-To: <8bd0f97a0803260736v58c11f8g8a5f740c62891174@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206579622-21915-1-git-send-email-cooloney@kernel.org>
	 <8bd0f97a0803260736v58c11f8g8a5f740c62891174@mail.gmail.com>
X-Google-Sender-Auth: afaac148957bbdd9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 10:36 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Wed, Mar 26, 2008 at 9:00 PM, Bryan Wu <cooloney@kernel.org> wrote:
>  >  +config JOYSTICK_AD7142
>  >  +       tristate "Analog Devices AD7142 Joystick support"
>  >  +       depends on BLACKFIN && I2C
>  >  +       ---help---
>  >  +         Say Y here if you want to support an AD7142 joystick
>
>  since you're going to send another patch anyways ;), this kconfig text
>  could use a line telling you the module name if built as a module.
>  -mike

No problem, I am waiting you guys to give some comments and update
this driver later.

Thanks
-Bryan
