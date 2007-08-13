Return-Path: <linux-kernel-owner+w=401wt.eu-S973624AbXHMSNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S973624AbXHMSNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S974334AbXHMR6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:58:55 -0400
Received: from smtp113.sbc.mail.re2.yahoo.com ([68.142.229.92]:27288 "HELO
	smtp113.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S974146AbXHMR6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:58:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Qw7FxO+06qZoh9K/McFm9jSTWfXnJV86OyBjkCtXsSs6+Dewg5TLTAHUumfs2OEM1gzB5DIpizKftelYzgWoHJu4/HBwRcUaaksyyXm9vQTttPh6CdwqLK5Cs9a3TMg1QGEvMw0FzcjMwd5rrxkRkeSsTIjy9HzZ6s6cPTbLgA0=  ;
X-YMail-OSG: Vu3zcGUVM1mhNLpStrjmSGGTmU9S5JkxVsnde47AtlD43nm108a0YbUEKVoIgh9OxPbr6DByDg--
From: David Brownell <david-b@pacbell.net>
To: "Midhun A" <midhunagni@gmail.com>
Subject: Re: USB HC on i.MX21 hangs with error -110
Date: Mon, 13 Aug 2007 10:58:56 -0700
User-Agent: KMail/1.9.6
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
References: <e1d5030b0708130751if39e36fx303e8cdaae21b927@mail.gmail.com>
In-Reply-To: <e1d5030b0708130751if39e36fx303e8cdaae21b927@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200708131058.56598.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 August 2007, Midhun A wrote:
>     We are using the i.MX21 Litekit. It has got a USB host port on it
> and the driver is imx21-hcd.c provided by the vendor.

Let's see ... Linux-ARM is a "please don't crosspost" list;
but you did (including linux-kernel).  And then you also
posted much the same message to linux-usb-users and then
linux-usb-devel.

In none of these messages do you report what that vendor said
about these problems ...

In short, a good lesson in how NOT to ask for help!

If anyone feels inclined to follow up on this, please do so
only on linux-usb-devel.

