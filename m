Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbZEHLSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbZEHLSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763479AbZEHLSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:18:21 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:38432 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757605AbZEHLST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:18:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kcYELhTz77vPI1Qqa8SdwoJRV0faFJHErV+3NPM0FLOqJ3Ij+NbMRb0WY7YrhWhBsr
         t+czOhyAt7lilJcdUFJyOpdRAc9DfyD7VYbQrE6eU+ie3xS18knWa+SkWXcd8x2Xrp/I
         0flLlTsDkBvqK+jHcuyYV9vZIC6bTtCsqrhy0=
Message-ID: <4A0414FD.8050909@gmail.com>
Date: Fri, 08 May 2009 13:18:21 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.7 Thunderbird/3.0b2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Ferenc Wagner <wferi@niif.hu>
Subject: Re: [PATCH 1/2] Char: rocket, fix ASYNC flags
References: <8763gcsa5e.fsf@tac.ki.iif.hu>	<1241771564-31133-1-git-send-email-jirislaby@gmail.com> <20090508121306.643f41c3@lxorguk.ukuu.org.uk>
In-Reply-To: <20090508121306.643f41c3@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2009 01:13 PM, Alan Cox wrote:
> cleaner to add ASYNCF_..

Heh, I have been thinking about that too, I'll post updated patches
later. Thanks.
