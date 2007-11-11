Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbXKKI57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbXKKI57 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 03:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbXKKI5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 03:57:52 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:13980 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753090AbXKKI5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 03:57:51 -0500
Message-ID: <4736C409.9040207@panasas.com>
Date: Sun, 11 Nov 2007 10:57:45 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Xavier Bestel <xavier.bestel@free.fr>, DervishD <lkml@dervishd.net>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Coding Style: indenting with tabs vs. spaces
References: <4732E6BA.8060001@panasas.com> <20071110120424.GA16067@DervishD> <1194697674.6176.1.camel@bip.parateam.prv>
In-Reply-To: <1194697674.6176.1.camel@bip.parateam.prv>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 11 Nov 2007 08:57:47.0185 (UTC) FILETIME=[EE233210:01C82440]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov. 10, 2007, 14:27 +0200, Xavier Bestel <xavier.bestel@free.fr> wrote:
> Le samedi 10 novembre 2007 à 13:04 +0100, DervishD a écrit :
>> Hi Benny :)
>>
>>  * Benny Halevy <bhalevy@panasas.com> dixit:
>>> I would like to hear peoples opinion about the indentation convention
>>> described below that I personally found the most practical with
>>> several different editors.
>> While I respect you opinion about tabs, I find tab indentation the most
>> evil thing ever invented. Even if done right (that is, not indenting
>> using a mixture of spaces and tabs), the only advantage is that you save
>> a few bytes.
> 
> Who cares ?
> The only advantage is that people can make tabs as big (or as small) as
> they wish. Tabs become "logical indentation". So one's indentation isn't
> forced on anotherone's editor.

Right.  That's exactly the point.
I find it harder to read someone else's code if (s)he uses 2 space indentation.
With tabs, when done right, I can expand to my personal preference.

> 
> 	Xav
> 
> 
