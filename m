Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbYJOP7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbYJOP7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 11:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYJOP7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 11:59:00 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:39736 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbYJOP67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 11:58:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=VhhtGjzBLYRvGcEd0IaF2314OnzQ1bypS9MoTOkYoXAKdI5fb/eM42Ov5WHxHLYU1g
         K207xGINsGE947rjlwh8QVtsCUoPbNXVQT06VsiEwnz2YvFxQA87vOWkCdcA9FQrpXOi
         iou5kSXxFsfRCCLM/dvkTW8mumir2vs2e5h+E=
Message-ID: <48F6133D.1070508@gmail.com>
Date: Wed, 15 Oct 2008 17:58:53 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] hang with ath5k
References: <a8e1da0810140142g633486br12c2799b2fa1670e@mail.gmail.com>
In-Reply-To: <a8e1da0810140142g633486br12c2799b2fa1670e@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2008 10:42 AM, Dave Young wrote:
> 1) run wpa_supplicant
> 2) ctrl + C
> 3) goto 1)

It doesn't happen here. How many iterations in average you need to reproduce this?
