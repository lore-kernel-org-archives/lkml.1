Return-Path: <linux-kernel-owner+w=401wt.eu-S1752037AbZITMqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbZITMqz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 08:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbZITMqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 08:46:54 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:39372 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbZITMqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 08:46:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=kKJ3YQGbcLlrPUS0jH2tyn9X3wTOZXVmc5/2B1HEtW12Uab4KgmprkKC94SKsF/T90
         EfcqfZ2cQZbk0+ihMVaUdmQ84CX09V9Zd4ucVkIMBaIX1YsYDI+g2Use/e2lTlZn7Mi0
         gbB/cw75cbw7ZpuW0aGX4Mi5cYuGV9Wfo1rwQ=
MIME-Version: 1.0
In-Reply-To: <68676e00909200520s7730b516v4e0d6c17d529d0a7@mail.gmail.com>
References: <c43b2e150909200120kf87cdc2oabafea8abbf01227@mail.gmail.com> 
	<68676e00909200520s7730b516v4e0d6c17d529d0a7@mail.gmail.com>
From: wixor <wixorpeek@gmail.com>
Date: Sun, 20 Sep 2009 14:46:37 +0200
Message-ID: <c43b2e150909200546p764978ecnb0606533c7dea542@mail.gmail.com>
Subject: Re: [lm-sensors] it87 sensors need an ACPI driver (2.6.31)
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: lm-sensors@lm-sensors.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 20, 2009 at 14:20, Luca Tettamanti <kronos.it@gmail.com> wrote:
> Try the asus_atk0110 driver, it handles the ACPI hwmon interface on
> Asus motherboards. If it does not work then please send a dump of your
> DSDT (/sys/firmware/acpi/tables/DSDT).

Works great, thank you very much.
