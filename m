Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbXFYVn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbXFYVn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbXFYVnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:43:49 -0400
Received: from mail.mimer.no ([213.184.200.1]:41426 "EHLO odin.mimer.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbXFYVns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:43:48 -0400
From: Harald Arnesen <harald@skogtun.org>
To: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
Cc: dwmw2@infradead.org, schilling@fokus.fraunhofer.de,
       linux-kernel@vger.kernel.org, david@lang.hm
Subject: Re: Linux Kernel include files
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
	<Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
	<467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de>
	<1182483527.10524.31.camel@shinybook.infradead.org>
	<467fdc75.0ficjl92unPDO1uk%Joerg.Schilling@fokus.fraunhofer.de>
	<1182785277.12109.121.camel@pmac.infradead.org>
	<87wsxrdi6e.fsf@basilikum.skogtun.org>
	<468024ec.9RebHj/O0BpNRyoY%Joerg.Schilling@fokus.fraunhofer.de>
Date: Mon, 25 Jun 2007 23:43:34 +0200
In-Reply-To: <468024ec.9RebHj/O0BpNRyoY%Joerg.Schilling@fokus.fraunhofer.de>
	(Joerg Schilling's message of "Mon, 25 Jun 2007 22:26:20 +0200")
Message-ID: <87ir9byak9.fsf@basilikum.skogtun.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling) writes:

>> If I actually install smake, as Jörg recommends, the message becomes:
>> smake: Can't find any source for 'CCOM_suncc'.
>> smake: Couldn't make 'CCOM_suncc'.
>
> Well, I was in hope that a small typo (in special as the correct spelling is in 
> the file README.compile) should not be a problem.
>
> You need to use CCOM=suncc 

Then it (star, I haven't tried cdrtools yes) compiles and links fine.
There must be something wrong with your Linux installation.
-- 
Hilsen Harald.

