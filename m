Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbZIZCtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbZIZCtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 22:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZIZCtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 22:49:39 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:37188 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZIZCti convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 22:49:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=b4jGYT0HPrM3f0zFw8sS6mTMtjrhHHQCdXw4cPW3kh0nh5hMCMukKoK+sa3HWt+3hM
         jRFYZWE+NzPn0/3ou7r5dGeae+HgyqK++AS5JstRRrfxFRI86roNrWOolJH/tD6MKmw7
         AZibqPm6bOMG50v4lO6p15K7tcWog/QxvPzFM=
MIME-Version: 1.0
In-Reply-To: <52241.192.168.10.89.1251990701.squirrel@dbdmail.itg.ti.com>
References: <52241.192.168.10.89.1251990701.squirrel@dbdmail.itg.ti.com>
From: vimal singh <vimal.newwork@gmail.com>
Date: Fri, 25 Sep 2009 19:49:22 -0700
Message-ID: <ce9ab5790909251949s71083c3brd625d36653387cc8@mail.gmail.com>
Subject: Re: [PATCH 0/2] mfd: restoring twl4030 power-off and power-button 
	capabilities
To: Tony Lindgren <tony@atomide.com>, vimal singh <vimalsingh@ti.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

Since there are no comments on these patches, can these go upstream?
Or, is there something to fix?

--vimal

On Thu, Sep 3, 2009 at 8:11 AM, vimal singh <vimalsingh@ti.com> wrote:
> This patch series restores the TWL Power-button and Power-off capabilities.
> Which were removed in "REMOVE OMAP LEGACY CODE" patches.
>
> Patches are compile tested only.
>
> [PATCH 1/2]: twl4030: register twl4030-pwrbuttonas a child of twl4030-core.c
> [PATCH 2/2]: twl4030: initialization of pm_power_off in twl4030-core.c
>
> Both patches are based on Felipe Balbi's patches posted earlier.
> http://lkml.org/lkml/2009/2/28/88
> http://markmail.org/message/ts4if3553qnauket
>
> --
> Vimal
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
