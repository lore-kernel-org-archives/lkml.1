Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbXFUULe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbXFUULe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755818AbXFUUL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:11:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:49912 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbXFUULZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:11:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EigWVE0O19L99ocws8hR73exn2ur3sn7HYm/1vq7MSsI3zE9cU6HYMMFvFxWLclQtSXxaYgFnCxkrqMEyvCRHmQYdGBT+nhFjVyzfvwPVVYd3zE5vKrYXCtags6NOkhTIflp3kyIWRfmtFkFctW2iOZ95AalQcruZ3gDNgi4UeA=
Message-ID: <68676e00706211311v3776aff2tff3b12074935742@mail.gmail.com>
Date: Thu, 21 Jun 2007 22:11:24 +0200
From: Luca <kronos.it@gmail.com>
To: "Alexey Starikovskiy" <aystarik@gmail.com>
Subject: Re: [lm-sensors] [RFC] ACPI based hwmon driver for ASUS
Cc: "Rudolf Marek" <r.marek@assembler.cz>, lm-sensors@lm-sensors.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <467ACE57.2010400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070513223329.GA29207@dreamland.darkstar.lan>
	 <46520F36.4080006@assembler.cz>
	 <68676e00705211453n69de6868lc5da2cad64f65699@mail.gmail.com>
	 <46528B6F.3050701@assembler.cz>
	 <20070602222829.GA11893@dreamland.darkstar.lan>
	 <467ACB2A.4070707@assembler.cz> <467ACE57.2010400@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/21/07, Alexey Starikovskiy <aystarik@gmail.com> wrote:
> Hi,
>
> I think you might be interested in following patch, which implements _ACPI_ driver for the same hardware...
> It is only "proof of concept" at the moment, but it does main thing -- reads hwmon device using ACPI interfaces.

Well, reading is easy and is already implemented in the driver that I
posted. The problem is to figure out how to control the various stuff
(fans, and maybe some of the other ASUS features).

Luca
