Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbYDJIXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbYDJIXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 04:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756598AbYDJIXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 04:23:23 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:2101 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554AbYDJIXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 04:23:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=voJZnToQ5dd8ZYFXcw8ecoNuB8QkxOeo4J8csqwesgR2uFL0O2bKETgK0na4hn3zncmbD3md1O4PGjg22cgwEcHukjmidy5hc701kjr/Nybl73oazuVTv6V1hJgr8w/Tl9QRFW/oDcmdPWEAweEby/zunyb9o9e+Iy27uar6VCQ=
Message-ID: <5699f8f00804100123q2a9d278arf9b076c91efbbd56@mail.gmail.com>
Date: Thu, 10 Apr 2008 10:23:15 +0200
From: "Wander Winkelhorst" <w.winkelhorst@gmail.com>
To: "Wappler Marcel" <Marcel.Wappler@bridgeco.net>
Subject: Re: Starting point: Suspend to RAM on embedded devices?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <83116F0A4FF67A4F97BA0B6E408C48E301E96208@zuerich.BC-Int.NET>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <83116F0A4FF67A4F97BA0B6E408C48E301E96208@zuerich.BC-Int.NET>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 10:14 AM, Wappler Marcel
<Marcel.Wappler@bridgeco.net> wrote:

>  - Is there a mainstream Linux platform (best if also ARM9 based) which has achieved this (a "suspend to RAM" like mode.) already?

The TomTom portable navigation devices (TomTom one, TomTom go etc.) do this.
They are based around an ARM CPU from Samsung and run Linux. If you
press the "power button" it actually does a suspend-to-ram.
They use a somewhat custom linux kernel, the source is available on
their website, www.tomtom.com/gpl
There is a website that aims to run open source software on the tomtom
(ie. not the tomtom navigation software) on http://www.opentom.org

Hope this helps,

Wander
