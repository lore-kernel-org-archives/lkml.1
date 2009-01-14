Return-Path: <linux-kernel-owner+w=401wt.eu-S1763483AbZANPcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763483AbZANPcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 10:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbZANPcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 10:32:07 -0500
Received: from sd-green-bigip-177.dreamhost.com ([208.97.132.177]:33088 "EHLO
	spunkymail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754154AbZANPcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 10:32:06 -0500
Message-ID: <496E056A.6020300@dawes.za.net>
Date: Wed, 14 Jan 2009 17:31:54 +0200
From: Rogan Dawes <lists@dawes.za.net>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Philippe De Muyter <phdm@macqel.be>
Cc: Xavier Bestel <xavier.bestel@free.fr>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux kernel without file system
References: <496DA678.1090701@wpkg.org> <20090114093422.GA9771@frolo.macqel> <1231926744.11907.12.camel@skunk> <20090114101828.GA15141@frolo.macqel> <496DF66B.3050609@dawes.za.net> <20090114145239.GB21043@frolo.macqel> <496DFD45.5030408@dawes.za.net> <20090114152423.GA24562@frolo.macqel>
In-Reply-To: <20090114152423.GA24562@frolo.macqel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe De Muyter wrote:
> On Wed, Jan 14, 2009 at 04:57:09PM +0200, Rogan Dawes wrote:
>> Ok, in that case, perhaps you should explain exactly what your
>> constraints are (target board, max memory/flash, etc), and maybe folks
>> will be able to provide more sensible answers.
> 
> if possible, mcf52236 (256k flash 32k sram in chip) :)

256kB flash? Good luck with that!

> kernel+uapplication XIP in flash
> 
> they seems to push something called utasker

Maybe it is the best solution . . .

Rogan
