Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbZF2MoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbZF2MoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 08:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbZF2MoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 08:44:04 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:63177 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbZF2MoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 08:44:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ngfofMUeuPy92JNSGusCnAaxYcBNOW0PIOEvMUGJoMRnIo0cSSOs3KS3Yey7rDhyst
         iIUBNFwfk4CB5NgTm1WzcY9T24iPDv3haw3wbkVFwmObaEA1NDoSZk+JM73eA/EB1J4Z
         DzDR2mxB0mpY9VbhnjK2pJR9SY7lGE93VFD/4=
MIME-Version: 1.0
In-Reply-To: <4A48A196.3060409@tuffmail.co.uk>
References: <4A48A196.3060409@tuffmail.co.uk>
Date: Mon, 29 Jun 2009 14:44:02 +0200
Message-ID: <71cd59b00906290544y71061c31p597efcb6c8ceeabd@mail.gmail.com>
Subject: Re: [PATCH] eeepc-laptop: fix hot-unplug on resume
From: Corentin Chary <corentin.chary@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 1:12 PM, Alan
Jenkins<alan-jenkins@tuffmail.co.uk> wrote:
> The patch below fixes a regression introduced by the rfkill rewrite.
> Please consider it for inclusion in 2.6.31 via the ACPI tree.
>
> Thanks
> Alan

Hi Len,

Please merge this patch in ACPI tree.
Thanks,

-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org
