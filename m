Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbYIJGCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbYIJGCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 02:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbYIJGCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 02:02:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:64496 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbYIJGCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 02:02:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GGySSOarEEl6nviugD0szdgNl7opU3BE9gHgRjP89ormVoikm50KYnwjyDePEiY1iy
         9dlfCa9/ROa5e60ZnuFBvoDMn3AyZqaxLKB1pN7pZ+c45nqNXV3j8QyvC8zfv3XhPt3j
         ajvvmah/LnHiVmEjYAzrJSjGh/S8rMgulzYg0=
Message-ID: <aa79d98a0809092302g60967a60sd0609044a6d6a137@mail.gmail.com>
Date: Wed, 10 Sep 2008 10:02:40 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86: io-apic - get rid of __DO_ACTION macro
Cc: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440809091313l6b3e1f48x6e3b5cd0b948ccf9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080909184615.GA7303@lenovo>
	 <86802c440809091313l6b3e1f48x6e3b5cd0b948ccf9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 12:13 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
...
>
> hope we can keep using MACRO..
>
> YH
>

Btw, Yinghai, what does it mean? To not touch this macro at all?
Or you mean about implementation issue (ie the design itself)?
