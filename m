Return-Path: <linux-kernel-owner+w=401wt.eu-S1762955AbYF3Phl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762955AbYF3Phl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 11:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYF3Phc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 11:37:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:44734 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbYF3Phb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:37:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cxLpNHYRfLwotzyuaCoGzzYU31oi21ptlw36fxIRN0vr19NeoC0W26CK48+6Z9TZYa
         AaMYKi/2nnXCBiut2EYozZUsht+JLzBsg9Bkrb2+IZ12vM3c/Xab9FFdOWMX8iBQrN8o
         slZg3T2V32tmYUGK1UpPitIccRsJ9AyRGHUu0=
Message-ID: <ca2dc2820806300837y32e41bbdqe605aaa1e303f65@mail.gmail.com>
Date: Mon, 30 Jun 2008 17:37:29 +0200
From: "Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: Drivers for selfmade hardware
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200806292147.52112.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806292147.52112.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2008 at 9:47 PM, Michael Buesch <mb@bu3sch.de> wrote:
>
> So what's the policy? Push to mainline or keep as seperate
> patch?
>

If it is simple enough, maybe you could describe the hardware (as
detailed as possible: models, schematics, ...) in a text file
somewhere at Documentation/ so there is no need to
maintain/update/change a link which could die in the future.
