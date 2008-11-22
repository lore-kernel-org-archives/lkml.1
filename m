Return-Path: <linux-kernel-owner+w=401wt.eu-S1758411AbYKVOIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411AbYKVOIY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 09:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758001AbYKVOIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 09:08:15 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:26574 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757968AbYKVOIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 09:08:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XGj5BzbDYv+jZ5kzPVAWr4FvQ5nxcYBjojxX9ACVyYGnbbktcHs6aIY3Dn17vecAPc
         hZ/n9L1+gGLALG/x5Z7YFDTVXM4pbE/urS2qZpw/9ZPijCxgkdGAlirxvFOCj5H4KnTN
         /y5OPiBXSGXAseUAuc8VzQW/cbCuh6dwXvyfM=
Message-ID: <f17812d70811220608r4faa9bbl3a82368d26326a87@mail.gmail.com>
Date: Sat, 22 Nov 2008 22:08:13 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: stefan@datenfreihafen.org
Subject: Re: [patch 10/14] LED: PCAP2 based LED driver
Cc: rpurdie@rpsys.net, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, "Daniel Ribeiro" <drwyrm@gmail.com>
In-Reply-To: <20081121160522.717181451@dodger.lab.datenfreihafen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081121160403.073751031@dodger.lab.datenfreihafen.org>
	 <20081121160522.717181451@dodger.lab.datenfreihafen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2008 at 12:04 AM,  <stefan@datenfreihafen.org> wrote:
>

What is that led->gpio being used for? Is it some assistant
GPIO to further control the LED? A bit confused.
