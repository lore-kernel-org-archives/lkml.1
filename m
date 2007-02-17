Return-Path: <linux-kernel-owner+w=401wt.eu-S932786AbXBQUed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbXBQUed (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 15:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932364AbXBQUed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 15:34:33 -0500
Received: from nz-out-0506.google.com ([64.233.162.231]:44008 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786AbXBQUed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 15:34:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=SWO/FbyAC9o/Xwo4ckqR/bbTyi++xEPN3O7Jd1xAou+G9IU49uwmNm/RTWpcuJX8n6Ti2v4c7avg/7vSxyae5FzE32RSA+hyrn+GBBB1dOrEO1lw+aq6rNPeOjJkYnuwqthAOBXvSU+m50y9IPyjLnWVx3ZfDZLygEsTfaH/5BU=
Message-ID: <75b66ecd0702171234h24779592w734fdd038677dba9@mail.gmail.com>
Date: Sat, 17 Feb 2007 15:34:29 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: Mockern@yandex.ru
Subject: Re: Analog-to-Digital Converter (ADC) driver
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45D760EB.000004.06949@pantene.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45D760EB.000004.06949@pantene.yandex.ru>
X-Google-Sender-Auth: fefbf192a19be9c8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/17/07, Mockern <Mockern@yandex.ru> wrote:
> Hello,
>
> Where I can find any ADC driver example?
>

Depending on what kind of ADC and what you want to do with it,
anything from a simple char device to an ALSA driver could be
appropriate.  Can you provide more information?

Lee
