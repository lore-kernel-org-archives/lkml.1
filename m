Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbXFKS1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbXFKS1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 14:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbXFKS04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 14:26:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:54540 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbXFKS0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 14:26:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oamhe5A8t4Kvtp19dht1krhVwAhhjwNxQb8wBinqps7jAMHQEKcOVaGrDcgsV5PePDQD82MgvYnZtmpyR66shof92+9VuHMBR1lnG7wIsI5EqSk2ZL53yDJOOclYHRkrHsm5QZ3GysmLTGa2TjKW6FSj7ka9DVa+Mm7ED57LZlE=
Message-ID: <d120d5000706111126w59c00bd2p826b7d9f588533ba@mail.gmail.com>
Date: Mon, 11 Jun 2007 14:26:54 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Paul Albrecht" <albrecht@rdi1.com>
Subject: Re: [BUG] via c3/2.6.20 -- ps/2 keyboard doesn't work with console
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1181582562.6982.5.camel@albrecht.rdi1.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1181236651.15435.1.camel@albrecht.rdi1.com>
	 <200706072323.05576.dtor@insightbb.com>
	 <1181325648.2437.5.camel@albrecht.rdi1.com>
	 <d120d5000706081208q217ca432w6cc6d860a84700e8@mail.gmail.com>
	 <1181582562.6982.5.camel@albrecht.rdi1.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 6/11/07, Paul Albrecht <albrecht@rdi1.com> wrote:
>
> Resending message from last week ... don't usually subscribe to the
> kernel mailing list so please cc me in your response.
>
> PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
> PNP: PS/2 controller doesn't have AUX irq; using default 12

Does it start working if you boot with i8042.noloop?

-- 
Dmitry
