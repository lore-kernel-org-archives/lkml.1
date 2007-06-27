Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbXF0Jtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbXF0Jtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 05:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbXF0JtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 05:49:23 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:40701 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbXF0JtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 05:49:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p/k3jv1U+QrfspWxctatg+7EL7326KI8ypw22AQt3Z9IKmKYqEh73mRLfS4cjPP6FmZ6bDaHme3aW80s3sF3EJi38lft2r8akZFT9cnR3ihpq/h/ZuwM+/Nrxw/jE5tGJIuIG9q3VPrL6isArMbsTKh8l1o+RHKkcDgramRhgng=
Message-ID: <6278d2220706270249v410d7b8eyfca9873d55075c75@mail.gmail.com>
Date: Wed, 27 Jun 2007 10:49:20 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Marc Perkel" <mperkel@yahoo.com>
Subject: Re: NVidia Driver Support - 1680x1050 mode
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <6278d2220706270247k21ccdd24x41b84c631b05fcc0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220706270247k21ccdd24x41b84c631b05fcc0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 Jun, 04:40, Marc Perkel <mperkel@yahoo.com> wrote:
> Trying to get my Asus M2NPV-VM motherboard and my
> Samsung SyncMaster 215tw Digital to work in 1680x1050
> mode but 1280x1024 is the most I can get. Chip Set is
> GeForce 6150.
>
> Looking in Xorg.0.log it ssems to think that the panel
> size is 1280x1024 in spite of my setting telling it
> differently.
>
> Sorry if this is off topic but I thought that the
> smart people would be here. In Windows I just plug it
> in and it works. So I figure Linux should work too. :)

Wrong list, but anyway...

If you're using a DVI cable, ensure it is dual-link.

Daniel
-- 
Daniel J Blueman
