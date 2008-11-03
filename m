Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbYKCO2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbYKCO2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 09:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbYKCO2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 09:28:24 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:28298 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409AbYKCO2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 09:28:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tNNlGanJbl7qwKuZAqjVSYOaAgD+HDQsl1ETAkmC3zcWQGeFMIeOhYL1GUMpOJrb4v
         6+jq6G0ngz+tIt4Wwd0mRsHD+7G9ktRwnIsFPemVLNLbmeBaexD/uXVYM+hm9be4kDFe
         1kk+T0wdsu+4c64gqBk+YUN6ScrizFBIwEvgA=
Message-ID: <b637ec0b0811030628x78ff7f4dgfed3c657882b9af2@mail.gmail.com>
Date: Mon, 3 Nov 2008 15:28:21 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: ACPI Warning (nspredef-0858): \_SB_.BAT0._BIF:
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <dd18b0c30811030624o2d8fe46u1e3e82d6f6b94481@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30811030624o2d8fe46u1e3e82d6f6b94481@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11822



On Mon, Nov 3, 2008 at 3:24 PM, Justin Mattock <justinmattock@gmail.com> wrote:
> Hmm,
> This is weired; I'm not sure but I think this might
> be caused by acpid or something in that area, i.g.
> doing a fresh install and loading the latest git leaves me
> without a warning message, but then after upgrading to intrepid
> I see this:
> [   11.116543] ACPI Warning (nspredef-0858): \_SB_.BAT0._BIF: Return
> Package type mismatch at index 9 - found Buffer, expected String
> [20080926]
>
>
> --
> Justin P. Mattock
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
