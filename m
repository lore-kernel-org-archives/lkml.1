Return-Path: <linux-kernel-owner+w=401wt.eu-S1751713AbYDEHPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbYDEHPX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 03:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbYDEHPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 03:15:10 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:31958 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbYDEHPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 03:15:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LwDJucYrQI0Fv5VaYBm6uwOdDVLzD6MsDWwdUFRrkfNDux3L12WdqYjyqzous6YaaE22bWYr+8jD7oU0v9SjR5LYEBBguH7y0dPjDrbfKm21KEfe4TwQE3KR7dFD7/y/whvYq0ku2/7eo+bz9BOhmHugd7Xt2VojzsmtYwQkA0s=
Message-ID: <5699f8f00804050015kb1ebb1cpf3ab8b587580fffd@mail.gmail.com>
Date: Sat, 5 Apr 2008 09:15:06 +0200
From: "Wander Winkelhorst" <w.winkelhorst@gmail.com>
To: "Rich West" <Rich.West@wesmo.com>
Subject: Re: sata_via
Cc: "Jeff Garzik" <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       "Linux IDE mailing list" <linux-ide@vger.kernel.org>
In-Reply-To: <47F6BD55.3090708@wesmo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47F694C8.8020507@wesmo.com> <47F6A5E8.1030602@garzik.org>
	 <47F6BD55.3090708@wesmo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 5, 2008 at 1:44 AM, Rich West <Rich.West@wesmo.com> wrote:

>  I'll give noapic a try, but (dumb question) what does acpi=off buy?

acpi=off surprisingly turns off ACPI
read more about acpi at:
http://en.wikipedia.org/wiki/Acpi

-Wander
