Return-Path: <linux-kernel-owner+w=401wt.eu-S1756634AbXEZAIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbXEZAIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 20:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbXEZAIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 20:08:15 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:63669 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbXEZAIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 20:08:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=PlONupXKDpL1tH0EM6MAsAdab7qBREUjts8/zWpyFoT0MIaioNJafed+wr3QFBuJzQfAlwRm7ffTCY8TfO/AryToxzKsnPcINit+kjGn1maOU7vmWuJZ++wTZjWoShq7lmsLPwOYdzCnwL8P4pRjmTuegmNK1NrMgNsZQEv+FQQ=
Message-ID: <2c04dc350705251708q64b6fed6y1237d6994b3e4fbe@mail.gmail.com>
Date: Sat, 26 May 2007 02:08:12 +0200
From: "Claudio Fontana" <claudio.fontana@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: trivial typo in CodingStyle patch
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I casually noticed this trivial typo while lurking the mailing list archives:

> Signed-off-by: Auke Kok <auke-jan.h.kok@xxxxxxxxx>
> [...]
> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
> index f518395..3635b38 100644
> --- a/Documentation/CodingStyle
> +++ b/Documentation/CodingStyle
> @@ -409,7 +409,36 @@ out:
> return result;
> }
>
> - Chapter 8: Commenting
> + Chapyer 8: Tests

s/Chapyer/Chapter/

Claudio
