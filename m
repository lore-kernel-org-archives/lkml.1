Return-Path: <linux-kernel-owner+w=401wt.eu-S1752458AbYICR7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbYICR7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbYICR64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:58:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:19856 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbYICR6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:58:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QZugV8Pbz2t7GGaONhVDeHj0cmUJ2eILm8a09T25J7Tcjw3eEUYJThC8W8/xZmwstK
         BrDaxEmCK4NDxVhuyL5zSzM65d2LfiIyasRDoQdWoXulFzAo3/Z6LVb1cyI9vlk0O0ar
         tWYeTKW4B6mGU/Q7Nn8aI7g/9wL3Djwj2jt7M=
Message-ID: <86802c440809031058g6cbeb697w7d5b2b2f15d01625@mail.gmail.com>
Date: Wed, 3 Sep 2008 10:58:54 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Alexey Kuznetsov" <ak@axet.ru>
Subject: Re: [Bugme-new] [Bug 11490] New: Old mtrr bug comeback
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <b38773640809031008o1b5f5417idbc6f0519e25a8d7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bug-11490-10286@http.bugzilla.kernel.org/>
	 <20080903091842.dc0982ee.akpm@linux-foundation.org>
	 <86802c440809030954s32ac76e3m3f6a17b89d0fc073@mail.gmail.com>
	 <b38773640809031008o1b5f5417idbc6f0519e25a8d7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 3, 2008 at 10:08 AM, Alexey Kuznetsov <ak@axet.ru> wrote:
> Can you explain what mean debug and initcall_debug?

put "debug initcall_debug" in to grub.conf or pxe conf.

YH
