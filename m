Return-Path: <linux-kernel-owner+w=401wt.eu-S1761279AbXGXNK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761279AbXGXNK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 09:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbXGXNKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 09:10:19 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:42565 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbXGXNKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 09:10:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Uo22GwBZxDUzIofGQLulyAniQpGNYkJOmuwiNHC1F2Pbg/bo+deJDIiGjchaIW1dwrKh2R8pfs4PveLzfZOdZISMplZXMLh5NOlqT6yJq3JatXrFlym8hkMTyz+FngKttZjSzLLlnCvZRxFa7ea2uDIyf9NYdqgUF6lWV80mTho=
Message-ID: <d120d5000707240610p5ef25c0ob0c7d4b3261624d9@mail.gmail.com>
Date: Tue, 24 Jul 2007 09:10:17 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Uwe Bugla" <uwe.bugla@gmx.de>
Subject: Re: Kernel 2.6.23-rc1: strange error messages in dmesg using a PS2 mouse
Cc: rubini@vision.unipv.it, linux-kernel@vger.kernel.org
In-Reply-To: <20070724130331.182480@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070724130331.182480@gmx.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On 7/24/07, Uwe Bugla <uwe.bugla@gmx.de> wrote:
> Hi everybody,
>
> I am using kernel 2.6.23-rc1 with a Logitech PS2 mouse.
> Although the mouse is fully functionable the following strange error messages appear in dmesg:
> psmouse: Unknown symbol serio_reconnect
> psmouse: Unknown symbol serio_open
> psmouse: Unknown symbol serio_close
> psmouse: Unknown symbol __serio_register_driver
> psmouse: Unknown symbol serio_unregister_child_port
> psmouse: Unknown symbol serio_unregister_driver
>

What is your .config?

-- 
Dmitry
