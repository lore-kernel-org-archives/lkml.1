Return-Path: <linux-kernel-owner+w=401wt.eu-S1761032AbXHUTmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761032AbXHUTmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 15:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755976AbXHUTma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 15:42:30 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:44597 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbXHUTm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 15:42:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eUJRuQVFEz0WC2Y8IECgRh9tr4rQwbKThkaOXLfHKr1YYpXOnmgWXYCb31dznm8QauMgpojmU+VL4EpruktIQewH9ICGDrypN1jq8Dbrhq7Ula1kDnQ1+JeKRuQMdPrUvXCYsWz0W2vixywU1lmimrczDYVXaSY5vdXPpNy8BRE=
Message-ID: <5dc6fd9e0708211242y40b9c31cud3d05f1910f04e5e@mail.gmail.com>
Date: Tue, 21 Aug 2007 12:42:27 -0700
From: "Hex Star" <hexstar@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: Re: Trouble booting with new 2.6.22.3 kernel
In-Reply-To: <Pine.LNX.4.64.0708212135040.20435@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5dc6fd9e0708211219p679116a4n48765e72e2253ddc@mail.gmail.com>
	 <200708212225.51987.ismail@pardus.org.tr>
	 <5dc6fd9e0708211228u433dbe04n7ca69e8b78ae29d@mail.gmail.com>
	 <5dc6fd9e0708211229q7c5df3a2q9ce00244d1b20019@mail.gmail.com>
	 <Pine.LNX.4.64.0708212135040.20435@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> success = (using_initramfs && ide == 'M') || ide == 'Y';


Thanks for the replies guys, I am building the ata_piix and
ata_generic drivers into the kernel now...hope this works :)
