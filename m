Return-Path: <linux-kernel-owner+w=401wt.eu-S1751185AbXCYF12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185AbXCYF12 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 01:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbXCYF12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 01:27:28 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:9315 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbXCYF11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 01:27:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AsVGk3klxAVKQAiE6N28BZTjo+PBF6JABMdfBaj3q1XQ0XM4ji9o4BD/aDmRq8mbQSTLG4e/OGFhNy+XHFJYGRLfxstuIL4tHBLfK5Evrm+RyzbyegvHIqa2XtP4ZTdaTKSbL+pzBm8Py25Dfjh6WtxkQcY/Fo03b8eKEY0sw7Y=
Message-ID: <82e4877d0703242227q7961833aie851e14764002264@mail.gmail.com>
Date: Sun, 25 Mar 2007 01:27:24 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Dmitry Torokhov" <dtor@insightbb.com>
Subject: Re: keyboard.c: Stop flooding dmesg with useless warnings
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <200703250115.02029.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703242315160.492@paragw-desktop>
	 <Pine.LNX.4.64.0703242333290.492@paragw-desktop>
	 <200703250115.02029.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Actually the keyboard driver should not emit input events for that key code.
> Is this a USB keyboard?
>
> --
> Dmitry
>

Yes this is a USB keyboard.

Any hint as to where I should start looking to make the driver not
emit input event for keycode==0?

Parag
