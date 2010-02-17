Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab0BQVgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 16:36:42 -0500
Received: from mail-gx0-f227.google.com ([209.85.217.227]:62824 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944Ab0BQVgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 16:36:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=KtSwLiKdkFCJb57RBxzpCmCDH/wZNq4MYJm/u2mkX0K2galltIeMZ6zPPFoyetA89q
         ZCdUKjZbklstXIOixYQWrziwAf07/mOZJlboeH+dBYR8HJ4QPV39zeGsPbwAeZjGCzIx
         Oc/N+osDxReeKMzqGo0FT6TuU7HpLp7dJOn+U=
References: <4B7C5E53.3030702@dell.com>
Message-Id: <4E509226-A1B8-4647-9541-7F276309949B@gmail.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bob Rodgers <Robert_Rodgers@dell.com>
In-Reply-To: <4B7C5E53.3030702@dell.com>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7C144)
Mime-Version: 1.0 (iPhone Mail 7C144)
Subject: Re: [PATCH] v3 - Add Dell Business Class Netbook LED driver
Date: Wed, 17 Feb 2010 13:36:17 -0800
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
       "lenb@kernel.org" <lenb@kernel.org>, Louis Davis <Louis_Davis@dell.com>,
       Jim Dailey <Jim_Dailey@dell.com>, Bob Rodgers <Robert_Rodgers@dell.com>,
       Mario Limonciello <Mario_Limonciello@dell.com>,
       Michael Brown <Michael_E_Brown@dell.com>,
       Matt Domsch <Matt_Domsch@dell.com>, Dan Carpenter <error27@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 17, 2010, at 1:23 PM, Bob Rodgers <Robert_Rodgers@dell.com>  
wrote:

> This patch adds an LED driver to support the Dell Activity LED on the
> Dell Latitude 2100 netbook and future products to come. The Activity  
> LED
> is visible externally in the lid so classroom instructors can  
> observe it
> from a distance. The driver uses the sysfs led_class and provides a
> standard LED interface. This driver is ready for submission upstream.
>
> Signed-off by: Bob Rodgers <Robert_Rodgers@dell.com>
> Signed-off-by: Louis Davis <Louis_Davis@dell.com>
> Signed-off-by: Jim Dailey <Jim_Dailey@dell.com>, Developers
> Acked-by: Matthew Garrett <mjg@redhat.com>
>

Looks good, thank you for making the changes.

Acked-by: Dmitry Torokhov <dtor@mail.ru>

-- 
Dmitry

