Return-Path: <linux-kernel-owner+w=401wt.eu-S1752896Ab0AHMYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab0AHMYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 07:24:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408Ab0AHMYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 07:24:05 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:42747 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab0AHMYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 07:24:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fQ8SrWULrXHHsGWPDRdrWWvRjU4/TcAfo17anlaqYTlT9Datg+YfZDtJgoBigmEtkI
         JMwGWYk3wsMdSaNdqTC73cAvAu+03YyHI6FboPdcqISH+gy1aPrYZX/lOovf2snhjA6D
         quuxQL3am9nkz9MVfy9Ri8HMpm83maM7j7k0I=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1001081133180.1461@er-systems.de>
References: <20100106234533.GC1960@kroah.com> <20100107180449.GA17495@suse.de>
	 <alpine.LNX.2.00.1001072033301.26784@er-systems.de>
	 <20100107194131.GA22983@suse.de>
	 <alpine.LNX.2.00.1001072125040.26784@er-systems.de>
	 <alpine.LNX.2.00.1001072141340.26784@er-systems.de>
	 <20100107220213.GA24882@suse.de>
	 <c18d6aa21001071603hbe4935clf78984fc837e4bd@mail.gmail.com>
	 <87wrztpgbh.fsf_-_@openvz.org>
	 <alpine.LNX.2.00.1001081133180.1461@er-systems.de>
Date: Fri, 8 Jan 2010 20:24:02 +0800
Message-ID: <9b5c9bb31001080424lebe52dfjb0c26bdc0868aba9@mail.gmail.com>
Subject: Re: [PATCH] quota: fix reserved space management for ordinary fs
From: Teck Choon Giam <giamteckchoon@gmail.com>
To: Thomas Voegtle <tv@lio96.de>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
       Dmitry Monakhov <rjevskiy@gmail.com>, Greg KH <gregkh@suse.de>,
       Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Patch works for me on top of 2.6.33-rc3 and on top of 2.6.31.11.

Also works for 2.6.32.3.

Thanks!

Kindest regards,
Giam Teck Choon
