Return-Path: <linux-kernel-owner+w=401wt.eu-S1758595AbYKVPrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbYKVPrg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 10:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758448AbYKVPr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 10:47:26 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:53051 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758438AbYKVPrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 10:47:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bOwGxPb0O901hNG5WoFwIyCNO8vdotBqvU05O47Je6NrdzAUWhim1nA0tOzQtVZuUY
         9Ft3fj3i5LxNUvcqvo+H048xciBqSIgFbCl+9gDEYKkD9ZhcHP7MiApCi5YkpdyuqLst
         TeBehrB46C7fJ9k9hnKmeo8oDVEcj0qfxST0A=
Subject: Re: [patch 10/14] LED: PCAP2 based LED driver
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: stefan@datenfreihafen.org, rpurdie@rpsys.net,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <f17812d70811220608r4faa9bbl3a82368d26326a87@mail.gmail.com>
References: <20081121160403.073751031@dodger.lab.datenfreihafen.org>
	 <20081121160522.717181451@dodger.lab.datenfreihafen.org>
	 <f17812d70811220608r4faa9bbl3a82368d26326a87@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 22 Nov 2008 13:46:47 -0200
Message-Id: <1227368807.19591.33.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sáb, 2008-11-22 às 22:08 +0800, Eric Miao escreveu:
> What is that led->gpio being used for? Is it some assistant
> GPIO to further control the LED? A bit confused.

Some leds are connected to a switch beside the led controller on pcap,
and both are needed to toggle the led.

-- 
Daniel Ribeiro

