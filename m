Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbXITOW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbXITOW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 10:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753814AbXITOWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 10:22:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:52592 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbXITOWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 10:22:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PTNl6k/WtqXsUr/orVnkSAK6950x0SVD4vtDW38drh6yImEt2b+bUyHI/BeS9W8HyiRTpZsue3dkWcsprUxicZdu0U+0oXhp+e6fekyBlXHhOFSWB90fifOb5Gwzdx2LUh9WYIeiHU2hlpJ3AYgY0vYqhydh/zQLu3wnn4j7xck=
Message-ID: <b6a2187b0709200722q2755111brb8b7c3bdc71e2129@mail.gmail.com>
Date: Thu, 20 Sep 2007 22:22:17 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: ACPI video mode patch review
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Pavel Machek" <pavel@ucw.cz>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0709201617440.24429@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46E9AD88.7070400@zytor.com>
	 <Pine.LNX.4.64.0709201617440.24429@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/20/07, Jiri Kosina <jikos@jikos.cz> wrote:

> With your patch applied, I get no video at all after resume (I tried all
> three possible combinations of acpi_sleep parameter).

Can you please try again with 2.6.23-rc7. The patch is already
included in -rc7 and it works for me on Lenono X60s.

Jeff.
