Return-Path: <linux-kernel-owner+w=401wt.eu-S1763244AbXFGQ7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763244AbXFGQ7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932215AbXFGQ6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:58:52 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:44811 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139AbXFGQ6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:58:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sn/a5mj1gZu/cJnMa1FT6wByq0PwaBimfDuw7QZ+iCZQRGpALV9v3w73D7xGLNx7dWz1NpDVvCmOYLJ59Tz59m0rVrTIe5ytrt7VuJz2pFwQCKclTGnBewrsmYZNj8DUHG2tJFIizFK5eGTsmc8DJGaC7ety92NwGRMcwhM6hpo=
Subject: Re: Add INPUT support to toshiba_acpi
From: Richard Hughes <hughsient@gmail.com>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Bastien Nocera <hadess@hadess.net>,
       John Belmonte <john@neggie.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
In-Reply-To: <200706030048.40393.dtor@insightbb.com>
References: <1180614979.2693.26.camel@localhost.localdomain>
	 <1180788652.2355.27.camel@localhost.localdomain>
	 <20070602142333.GA3452@srcf.ucam.org>
	 <200706030048.40393.dtor@insightbb.com>
Content-Type: text/plain
Date: Thu, 07 Jun 2007 17:58:59 +0100
Message-Id: <1181235539.2610.72.camel@work>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-03 at 00:48 -0400, Dmitry Torokhov wrote:
> 
> 
> It looks like KEY_COFFE comes from 0x0c/0x19e - AL Terminal
> Lock/Screensaver
> so your interpretation is indeed correct. I guess I better add an
> alias to
> input.h

What's the status of this patch? Good for merging? Do you want me to
redo the current patch using input-polldev and the new setkeycode stuff?

Richard.

