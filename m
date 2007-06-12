Return-Path: <linux-kernel-owner+w=401wt.eu-S1757813AbXFLSsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813AbXFLSsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 14:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757035AbXFLSsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 14:48:11 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:38046 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756592AbXFLSsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 14:48:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Hnr3PWWypkWRou00tZskmVBvteotH19qawKQcZ48R1aGPpXzjBVk9KNatlGiVbDc3ZECA9Ilwly69kA+0vx5ljWPst6gpmkAtBFsPNEO01IksbHdUU/Xhza2Eq871+N1fk5EuY0Ijk8SspjwmrplmT2bfmrxR5hbUqSE1P5Z/04=
Message-ID: <d120d5000706121148r5b24c710x7d32e00c436699af@mail.gmail.com>
Date: Tue, 12 Jun 2007 14:48:08 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Hans de Goede" <j.w.r.degoede@hhs.nl>
Subject: Re: PATCH: fix mismatch between usb-hid.c HUT find/search mapping and the HUT reference doc
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Vojtech Pavlik" <vojtech@suse.cz>, sbrabec@suse.cz,
       "Richard Hughes" <hughsient@gmail.com>
In-Reply-To: <466EE06B.9030202@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466EE06B.9030202@hhs.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/07, Hans de Goede <j.w.r.degoede@hhs.nl> wrote:
> Hi all,
>
> As some of you might know from my earlier post/thread about atkbd and softraw,
> I'm currently working on getting keyboards with internet/easy access keys to
> work painlessly / plug and play.
>

BTW, Richard Hughes (CCed) is also trying to fix keyboard mappings (by
loading proper keymap into kernel with support of HAL).

-- 
Dmitry
