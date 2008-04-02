Return-Path: <linux-kernel-owner+w=401wt.eu-S1759328AbYDBXKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328AbYDBXKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 19:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757156AbYDBXKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 19:10:41 -0400
Received: from main.gmane.org ([80.91.229.2]:39278 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757154AbYDBXKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 19:10:41 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stefan Schweizer <genstef@gentoo.org>
Subject: Re: suspend
Followup-To: gmane.linux.kernel
Date: Thu, 03 Apr 2008 01:09:01 +0200
Message-ID: <ft13p5$h64$1@ger.gmane.org>
References: <dd18b0c30804012331oc548416k113e492d7dc9c189@mail.gmail.com> <200804021419.06672.rjw@sisk.pl> <dd18b0c30804020853w50e0290cy8b0303e30f2bcfec@mail.gmail.com> <200804021939.46733.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ppp-82-135-8-6.dynamic.mnet-online.de
User-Agent: KNode/0.99.01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:

> On Wednesday, 2 of April 2008, Justin Mattock wrote:
>> Hello; the only problems I see after a suspend is the appletouch
>> looses its scroll function,
> 
> Is that a USB device or some other kind?

I have the same Problem on my macbook 13,3" using the appletouch usb module
to drive the touchpad. chvt 1; chvt 7 brings the touchpad back after resume
but do you maybe know a better solution?

Best regards,

