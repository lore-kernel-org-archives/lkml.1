Return-Path: <linux-kernel-owner+w=401wt.eu-S1765542AbYEFQZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765542AbYEFQZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbYEFQYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:24:49 -0400
Received: from ribosome.natur.cuni.cz ([195.113.57.20]:52366 "EHLO
	ribosome.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbYEFQYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:24:48 -0400
Message-ID: <48208647.3090500@ribosome.natur.cuni.cz>
Date: Tue, 06 May 2008 18:24:39 +0200
From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@ribosome.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080328 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Robert Hancock <hancockr@shaw.ca>, Jan Engelhardt <jengelh@medozas.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23.17 & 2.6.24.5 and maybe earlier: pata_marvell: need to
 disable DMA to get rid of '(ATA bus error)', 'ata7.00: status: { DRDY ERR
 }', 'ata7.00: error: { ICRC ABRT }'
References: <fa.+9Q+WQnyiYTlpbXVIzn6aT2/gS0@ifi.uio.no>	<fa.fKUfeQYS9BFD60fOMormQ25ard4@ifi.uio.no>	<fa.QYXSW2xjSxf6xnmd0rQGJhHLnrc@ifi.uio.no>	<fa.qfeYSQtlsXzGvFvBQEdF9TFFpNg@ifi.uio.no>	<481BD12D.1030406@shaw.ca>	<4820529D.2040609@ribosome.natur.cuni.cz>	<20080506140825.759db8f2@core>	<4820711C.1010902@ribosome.natur.cuni.cz> <20080506160452.61725e6c@core>
In-Reply-To: <20080506160452.61725e6c@core>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> O> /dev/sde:
>> ATA device, with non-removable media
>>         Model Number:       Delock 54111 512MB                      
>>         Serial Number:      
>>         Firmware Revision:  Ver1.27 
> 
> Does seem to think its ATA not CFA I guess you'll need to specify pio for
> that device specifically.

Sorry for my ignorance ... How?
