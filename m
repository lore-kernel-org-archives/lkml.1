Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbZCPK73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbZCPK73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 06:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbZCPK7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 06:59:20 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:33179 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbZCPK7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 06:59:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OTl+m4cHPHh0AtNGYjO+XfJfqoZoRekrW01B3j4Wh0hmA/nBYmUUl+Th9ZwuD1ASO8
         l5z4GdApVdkrjafojDy36afuC8ILMqqB6sqLzR97lU23qgroD+fokexXrll9Q4UmhH+P
         V8Hou7azrFLGGntn35bsPJy5WQeqF/1uXYzBg=
Message-ID: <49BE3102.6090302@gmail.com>
Date: Mon, 16 Mar 2009 11:59:14 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Char: isicom, prolong tty reference holding
References: <1237199665-10675-1-git-send-email-jirislaby@gmail.com> <20090316105026.610a0b9a@lxorguk.ukuu.org.uk> <49BE3052.5080801@gmail.com>
In-Reply-To: <49BE3052.5080801@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.3.2009 11:56, Jiri Slaby wrote:
> Hmm, but the tty_port_tty_set drops the reference, right?

I see it. Ignore this.
