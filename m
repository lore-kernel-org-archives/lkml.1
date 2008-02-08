Return-Path: <linux-kernel-owner+w=401wt.eu-S1762255AbYBHVDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762255AbYBHVDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbYBHVDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:03:11 -0500
Received: from qb-out-0506.google.com ([72.14.204.225]:15661 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355AbYBHVDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:03:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=C8F/Yi4LshE4qvebyCr9CVxCWMB2Cr3B0G6Il69LPxxxdMnIcyhjCXWX193B3Y9yCDi3bnwegupPVoSrNonPuAlP/7/h7JOnX5z/TAdYBlXaU8OtrRtRWaNhUlxmAI26QIU2dTNIm/JhuNvv96hRuBaaB4UYq519so3D8mN8Y20=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH] ide-cd: replace ntohs with generic byteorder macro be16_to_cpu
Date: Fri, 8 Feb 2008 21:39:16 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080208062903.GA20018@gollum.tnic>
In-Reply-To: <20080208062903.GA20018@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802082139.16877.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 February 2008, Borislav Petkov wrote:
> commit d41c6bc739e7ea7880f7f5983a9694f2e0214d92
> Author: Borislav Petkov <petkovbb@gmail.com>
> Date:   Fri Feb 8 07:25:44 2008 +0100
> 
>     ide-cd: replace ntohs with generic byteorder macro be16_to_cpu
>     
>     Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied
