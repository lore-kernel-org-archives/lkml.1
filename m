Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbXHUUDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbXHUUDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 16:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbXHUUDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 16:03:40 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:49088 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbXHUUDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 16:03:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=e1UjPluPUYXeFQ3ra0/MCR41fzpTjCQV8ggVv7txBclFuwY8B42alB/PEQVxgKLWGXW10gbnjTPnMkwY597OYiXAtnbemaCFLc2D6yBNPO78nzkPKp/GRiMlf/QaPIJF1TxPxUG7GVa7C3Ii8JwXGpUbW9Ty1xxmCfm8nt5KmXU=
Message-ID: <5dc6fd9e0708211303h235256b2ra71c2025f101478@mail.gmail.com>
Date: Tue, 21 Aug 2007 13:03:37 -0700
From: "Hex Star" <hexstar@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: Re: Trouble booting with new 2.6.22.3 kernel
In-Reply-To: <Pine.LNX.4.64.0708212157530.20435@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5dc6fd9e0708211219p679116a4n48765e72e2253ddc@mail.gmail.com>
	 <5dc6fd9e0708211226k3f931579x6f8b3ab275f93c35@mail.gmail.com>
	 <5dc6fd9e0708211227k22f9e214vd8132913214716b3@mail.gmail.com>
	 <200708212256.59281.ismail@pardus.org.tr>
	 <Pine.LNX.4.64.0708212157530.20435@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> - which is why people use initramfs. It's all perfect.
>
> >Perfect is the enemy of good
>
>
>         Jan
> --

How would I go about setting up a initramfs for the kernel? The book
I'm referring to to help me learn kernel compilation and installation,
"Linux Kernel In A Nutshell" by Greg Kroah-Hartman doesn't mention how
to create a initramfs... Thanks! :)
