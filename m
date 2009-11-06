Return-Path: <linux-kernel-owner+w=401wt.eu-S1759397AbZKFQc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397AbZKFQc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 11:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757641AbZKFQcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 11:32:55 -0500
Received: from mail-iw0-f180.google.com ([209.85.223.180]:38002 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbZKFQcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 11:32:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=qg+s46Jh7af286x72rrbKj9B3bzln5ix04ycwbnqoK8bJSU7P2mHUd43NYpaVMIz+T
         Npyn9ZnrOvpLpuvG3P8TsLWr6RcBeH9Qv6LLCprOk4EjaGtd/cVxbthmtyInHf1q6mwn
         CVfUF2UGF+p2xmJ5tBIioJTyfq/9wUAY+vZPM=
MIME-Version: 1.0
In-Reply-To: <1257484663.2873.622.camel@calx>
References: <43e72e890911051654i19c18bf3nd397662ed79712c4@mail.gmail.com> 
	<1257484663.2873.622.camel@calx>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 6 Nov 2009 08:32:40 -0800
Message-ID: <43e72e890911060832k1b831f32w93357c71b370e71c@mail.gmail.com>
Subject: Re: Using netconsole and getting double prints
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 5, 2009 at 9:17 PM, Matt Mackall <mpm@selenic.com> wrote:
> On Thu, 2009-11-05 at 16:54 -0800, Luis R. Rodriguez wrote:
>> I'm getting double prints when using netconsole. This used to happen
>> to me and then I just enable debugging log level manually (dmesg -n 8)
>> but now no matter what I try I always get double prints.
>
> This is the first report I've seen of that. Recommend investigating with
> wireshark.

Matt, did you really mean wireshark? I'm a wireless guy so wireshark
to me is this:

http://www.wireshark.org/

The prints have nothing to do with protocols though. I can get a
double print on a simple hello world driver.

  Luis
