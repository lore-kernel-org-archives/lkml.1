Return-Path: <linux-kernel-owner+w=401wt.eu-S1759392AbZD1Nhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392AbZD1Nhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 09:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbZD1Nhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 09:37:34 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:64273 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418AbZD1Nhd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 09:37:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=G3wJb/eQtKjwT5I62Q/xDo7icK5kN8FvdFJUm3/exbvN0mpevkDWOvd+PfhmrWDTFY
         uIsa/NqO8//AlrLBhY+CScsjSI9A4vqZo1HgQ8VdGRgS4RQvVmYf5N7Bhkc0FsnDESpz
         Zo8UJRkO7Y/WfWE7nW2icNnEunzNKjqTix4hs=
MIME-Version: 1.0
In-Reply-To: <49F7059A.6000901@tremplin-utc.net>
References: <b637ec0b0904280609h2583e72ds38867bdf7867a0a2@mail.gmail.com>
	 <49F7059A.6000901@tremplin-utc.net>
Date: Tue, 28 Apr 2009 15:37:32 +0200
Message-ID: <b637ec0b0904280637r675ef826v543a8e9b4796141c@mail.gmail.com>
Subject: Re: OT - Regression: Cisco VPN module hangs 2.6.30-rcX
From: Fabio Comolli <fabio.comolli@gmail.com>
To: =?UTF-8?Q?=C3=89ric_Piel?= <eric.piel@tremplin-utc.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric.

On Tue, Apr 28, 2009 at 3:33 PM, Éric Piel <eric.piel@tremplin-utc.net> wrote:
> Fabio Comolli schreef:
>> Hi all.
>> Please forgive me if this question is considered offtopic on this
>> list. I'm not sure where to post it.
>>
>> Anyway, I have a regression between 2.6.30-rcX and every other version
>> I tried with regards to Cisco proprietary cisco_ipsec.ko module.
>>
>> The module compiles cleanly, loads and the VPN connection is created.
>> So far so good. The problem is that as soon as I send packets on the
>> tunnel (TCP - UDP doesn't matter, even a nslookup quesry i enough),
>> the system hangs without messages on console / logs. Powercycle is
>> needed.
> Hello,
>
> Have you tried using vpnc [1]? Nowadays it works very well (for
> connecting to cisco VPNs) and it doesn't require you to recompile
> anything whenever you change of kernel. As a bonus, it's opensource ;-)
>
> Eric
>
> [1] http://www.unix-ag.uni-kl.de/~massar/vpnc/
>

Yes, I tried very hard, digging in forums, lists and so on. All without success.
Plus, I need the VPN to connect to my employer's network where the
only supported tool is the proprietary Cisco one. So no help on that
side :-(

Regards,
Fabio
