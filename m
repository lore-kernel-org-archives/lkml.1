Return-Path: <linux-kernel-owner+w=401wt.eu-S1751213AbZLMHEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213AbZLMHEw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 02:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbZLMHEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 02:04:50 -0500
Received: from claw.goop.org ([74.207.240.146]:45511 "HELO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750852AbZLMHEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 02:04:49 -0500
Message-ID: <4B249210.7060103@goop.org>
Date: Sat, 12 Dec 2009 23:04:48 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091203 Fedora/3.0-3.13.rc2.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: liu weni <qingshenlwy@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Toralf_?= =?ISO-8859-1?Q?F=F6rster?= 
	<toralf.foerster@gmx.de>
Subject: Re: [PATCH v2]kernel: remove mess codes
References: <b3657a100912122255j138bb9e6s785bdc8152a27691@mail.gmail.com>
In-Reply-To: <b3657a100912122255j138bb9e6s785bdc8152a27691@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/09 22:55, liu weni wrote:
> I found some mess characters(0x0c) in the kernel source code.
> Then I suggest remove it.
>    

Those are form-feed characters.   Some editors use them to separate 
logically distinct blocks of code into separate "pages".

     J
