Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbXGLFcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbXGLFcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 01:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbXGLFce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 01:32:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:56416 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbXGLFcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 01:32:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=OTicvJ/aAVyBBBA2stUrv8VO12e1qF3JOOCw3Onraorf2bVUSEMWYdY6xQuRzCTSp+UVfn082Ub0uZ5oqY7oALqKLeSEGvClfqsYCjqHn4CCfGSQ/QitqRA4pS6CNPgtUyjuNue8F1Zu6Tdn8+DfQVXsLh8AsIHk2NxgSd2QxJM=
Message-ID: <4695BCEA.4060108@gmail.com>
Date: Thu, 12 Jul 2007 09:32:26 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Jan Engelhardt <jengelh@computergmbh.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@stusta.de>,
       Zhang Rui <rui.zhang@intel.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] the scheduled ACPI_PROCFS removal
References: <20070709145755.GD3492@stusta.de> <20070709174544.2a6b7067@the-village.bc.nu> <Pine.LNX.4.64.0707092044520.2887@fbirervta.pbzchgretzou.qr> <46951969.4030109@tmr.com>
In-Reply-To: <46951969.4030109@tmr.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> [*] Does someone have an alternative for
>> /proc/acpi/battery/BAT1/{state,info}?
I'm working on it. Should have proto by the end of week.

Regards,
Alex
