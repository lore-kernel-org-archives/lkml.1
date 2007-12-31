Return-Path: <linux-kernel-owner+w=401wt.eu-S1752293AbXLaRr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbXLaRr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 12:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbXLaRrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 12:47:48 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:1043 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751225AbXLaRrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 12:47:47 -0500
Message-ID: <47792B3E.60509@panasas.com>
Date: Mon, 31 Dec 2007 19:47:42 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Marco Costalba <mcostalba@gmail.com>
CC: Filippo Zangheri <filippo.zangheri@yahoo.it>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Git Mailing List <git@vger.kernel.org>
Subject: Re: [ANNOUNCE] qgit-2.1 and qgit-1.5.8
References: <e5bfff550712302335ie96e143g55c93e984fba6aaa@mail.gmail.com>	 <4778CB78.2010906@yahoo.it> <e5bfff550712310358g347d883fm9866f328f24e3ad0@mail.gmail.com>
In-Reply-To: <e5bfff550712310358g347d883fm9866f328f24e3ad0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Dec 2007 17:47:44.0817 (UTC) FILETIME=[3FA84A10:01C84BD5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31 2007 at 13:58 +0200, "Marco Costalba" <mcostalba@gmail.com> wrote:
> On Dec 31, 2007 11:59 AM, Filippo Zangheri <filippo.zangheri@yahoo.it> wrote:
>> Hi,
>>
>> I git-cloned qgit-2.1 from your repository, then ran `qmake qgit.pro`, but `make` gave me errors.
> 
> Yes, you need qmake of Qt4 not the Qt3 one.
> 
<snip>

A Theoretical question.
Is it possible to compile Qt4 app all statically linked and run it on a Qt3 based KDE
machine. Some thing like the windows installation, where every thing is self-contained?

Thanks
Boaz
