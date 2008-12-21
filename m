Return-Path: <linux-kernel-owner+w=401wt.eu-S1752434AbYLUXP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbYLUXP0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 18:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbYLUXPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 18:15:15 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:45820 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbYLUXPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 18:15:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dpOpTBt8KNogWlpPCGq0aKHLdON0z/oMQG94rZ+H5bDOP4m0etqkhH60gGxxsFmeKg
         oHY/Y1npspkhUvRniZwfl3TReHxHMQlcNml2kdD8DRCt7OpAQM6LKu8RWus/xO42+RTn
         Xl+0JqgVsGGLyYCiUtI+fRTZFgk00MdC0v4Ps=
Message-ID: <20f65d530812211515q63b4c9f1gc5d4325adc74f7e6@mail.gmail.com>
Date: Mon, 22 Dec 2008 12:15:13 +1300
From: "Keith Chew" <keith.chew@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: bug or hardware memory error?
In-Reply-To: <20081221202730.GB6800@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20f65d530812211205m1df7c210w873f25cd2a26ce8b@mail.gmail.com>
	 <20081221202730.GB6800@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Willy

> well, it could be any. 2.6.20.1 is very old, even for the 2.6.20 branch.
> A few hundreds of bugs have been fixed since. If you don't need to stick
> to 2.6.20, you should try 2.6.27.10. If you need to stick to 2.6.20 for
> whatever reason, please at least try with 2.6.20.21 (the latest 2.6.20
> patch). Even with that, there's no guarantee that the present bug will
> be fixed though.
>

Ok, will try the latest kernel to see if that fixes it. 2.6.20.1 was
actually the latest kernel when I rolled it out to these machines. The
IRQ Lockup messages have never caused any problems to the the
application, but only recently I caught the stack trace. Of course I
may have missed catching these stack traces in the past, but they are
rare.

Thanks again for your input.

Regards
Keith
