Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbXIBDor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbXIBDor (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 23:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbXIBDoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 23:44:38 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:21641 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbXIBDoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 23:44:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OgTM6AQEoXQ7svaV5Y/YcFnmtw6iogBooXxuAcbCGkIkBU6ywFVuAERwT4P6zNjDDQwMiPkjw5LkxeSuYvLt1DJE/McAhZQUwvwGcrGmPjixAKxxJy+Pj9fLeSKSpKB+oYJRXrgaE4WtqCmmtBr81YY1qX7riOmY26n15F/ZSj4=
Message-ID: <8bd0f97a0709012044p4e7826e2s46368e519bd349e@mail.gmail.com>
Date: Sat, 1 Sep 2007 23:44:36 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bill Davidsen" <davidsen@tmr.com>
Subject: Re: the Linux kernel, testsuites, and maybe *you*
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <46DA2133.5000809@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0708311422u309ff09cs24dfe64ff535a982@mail.gmail.com>
	 <46DA2133.5000809@tmr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/1/07, Bill Davidsen <davidsen@tmr.com> wrote:
> If you want to test that stuff and run it on the current code in the
> kernel, how about a kernel module? You could "modprobe sanitytest" or
> something and report to syslog at module load time. And maybe have a
> parameter which does something drastic if something core is so hosed
> that filesystem damage is likely. Or just optional init code run by a
> kernel option, perhaps sanity testing after boot is not a great idea.

i'm fully capable of doing my own testing right now; that isnt the
point of this thread ... the point is for everyone to benefit, not
just the Blackfin architecture
-mike
