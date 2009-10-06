Return-Path: <linux-kernel-owner+w=401wt.eu-S933289AbZJFXLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289AbZJFXLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 19:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757668AbZJFXLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 19:11:31 -0400
Received: from mail-yx0-f173.google.com ([209.85.210.173]:35888 "EHLO
	mail-yx0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756887AbZJFXLa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 19:11:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QuQSEArGiuoTlctQmHoKdsVKpQCSoT2ozBEIUJ21+MGiLCIN62pxtRH3pThIPjaeSY
         bvuGYtxsoAfZhQqES8GOp42DYy4oIRSf8gRB2U1T0H6TV9lZ44NAgsAHDINKY931C8DZ
         eHEYrfXwT1evQoCHKnx7pNTPjOw7r9rqN8NoU=
MIME-Version: 1.0
In-Reply-To: <63386a3d0910061406p32e514cdjbe6059e7af60fb87@mail.gmail.com>
References: <63386a3d0910061406p32e514cdjbe6059e7af60fb87@mail.gmail.com>
Date: Wed, 7 Oct 2009 04:40:52 +0530
X-Google-Sender-Auth: 0e05a746532897e7
Message-ID: <661de9470910061610n53bd0de0gdeb8dec854ef679a@mail.gmail.com>
Subject: Re: CGFreak control group visualizer
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 7, 2009 at 2:36 AM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> A while back I started to write CGFreak to visualize the intricacies of control
> groups using some python and cairo. (Nothing special, just a hobby - famous
> last words.) I have a web page of it running with some explanations of what
> you see here:
>
>  http://cgfreak.sourceforge.net/
>
> The basic idea is that resources can often be represented in piecharts,
> everyone should be familiar with these from school and economists love
> them. So I visualize system resources in control groups as piecharts and
> now I have also started to make it a bit interactive. It all grew out of the
> educational need to understand scheduling and control groups.
>
> I don't know if you think this is as fun as I think, it's nice images anyway,
> I don't know how accurate they are, feedback and patches welcome.

I looked at the screenshots and they look very interesting. Would it
take a lot of effort to extend it to track other controllers like
memory, network, etc?

Balbir Singh.
