Return-Path: <linux-kernel-owner+w=401wt.eu-S1761857AbYBFLUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761857AbYBFLUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 06:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbYBFLT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 06:19:57 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:8417 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbYBFLT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 06:19:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=hXSKf2F6X0JKZCEYp6cFWg26/EUmAY5HE/wE1RKxp8zBh2zJ3msvpVOfOpdp04BRMPs+6HWHx8rMNnEHFpMkUCYg/nnX28Bq8RziMkDeBed+exwgeD4NfcH+dRcVV1SsJMb+b58otThzFKaNCBT8d56GTvg44SRNGxcn2bRsKwY=
Message-ID: <2f11576a0802060319qcd3149bqd987ab7c6613f50a@mail.gmail.com>
Date: Wed, 6 Feb 2008 20:19:55 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.24-mm1
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080206111524.GA13264@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080203171634.58ab668b.akpm@linux-foundation.org>
	 <2f11576a0802060313k3f17547ev4d2643c3a130f59f@mail.gmail.com>
	 <20080206111524.GA13264@elte.hu>
X-Google-Sender-Auth: 7ea1cc617359f9c5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> should be fixed by the commit below. (already upstream)
>
>         Ingo

Oops, sorry ;-)
