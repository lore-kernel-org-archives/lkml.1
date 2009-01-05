Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbZAEOsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbZAEOsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbZAEOrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:47:51 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:40817 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbZAEOrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:47:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=J6Tkcluc014+JmnsJimbU7lSLqvqH93vObIY9Y3RoT/oIIOm/gk63K6/nZ61C8TfEy
         v7+FosfcFNUwcPcKykRmI+jrKwQS9NHQrloE3NaDPyCnqUvfsjDsMQtq7uaUxoc0AP/O
         JccN3mGv5sw3+xOjaHxW4Mpr8duEkxRDqhxJk=
Message-ID: <3f9a31f40901050647j5c374e8o36711bae1eb2a5@mail.gmail.com>
Date: Mon, 5 Jan 2009 20:17:47 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [PATCH -net-next 3/4] firmware: convert tg3 driver to request_firmware()
Cc: "Oliver Hartkopp" <oliver@hartkopp.net>,
       "Jaswinder Singh Rajput" <jaswinder@infradead.org>, davem@redhat.com,
       jgarzik@redhat.com, netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       mchan@broadcom.com, "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1231165351.8286.279.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1230626497.24796.26.camel@jaswinder.satnam>
	 <49620AFE.6040409@hartkopp.net>
	 <3f9a31f40901050612v700d2542r1e3e400bf0fe3d33@mail.gmail.com>
	 <1231165351.8286.279.camel@macbook.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2009 at 7:52 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Mon, 2009-01-05 at 19:42 +0530, Jaswinder Singh Rajput wrote:
>>
>> David Woodhouse: Do you have any plans to support firmware by using modules.
>
> Que?
>

Ohh, got it thanks :-)

JSR
