Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbYAaAiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbYAaAiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 19:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbYAaAiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 19:38:16 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:25608 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbYAaAiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 19:38:16 -0500
Date: Wed, 30 Jan 2008 18:38:07 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: The hardware reports a non fatal,
 correctable incident occurred on CPU 0
In-reply-to: <fa.emGc7bzWVjoFStw5zg+L1ORRM1s@ifi.uio.no>
To: Badalian Vyacheslav <slavon@bigtelecom.ru>
Cc: linux-kernel@vger.kernel.org
Message-id: <47A1186F.9080204@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.emGc7bzWVjoFStw5zg+L1ORRM1s@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Badalian Vyacheslav wrote:
> Hello all.
> Can anyone say to me that messages its normal =)
> 
> [63617.120342] MCE: The hardware reports a non fatal, correctable 
> incident occurred on CPU 0.
> [63617.120353] Bank 3: cc00000000100100
> [63632.092712] MCE: The hardware reports a non fatal, correctable 
> incident occurred on CPU 0.
> [63632.092723] Bank 3: cc00000000100100
> [63647.065081] MCE: The hardware reports a non fatal, correctable 
> incident occurred on CPU 0.
> [63647.065091] Bank 3: cc00000000100100
> [63662.037453] MCE: The hardware reports a non fatal, correctable 
> incident occurred on CPU 0.
> [63662.037463] Bank 3: cc00000000100100
> 
> Or i need send to you my lspci to add my motherboard or some chip to 
> some blacklist?
> I understand that MCE is*  Machine Check Exception.  =)*

What kind of hardware is this? You likely have some bad RAM or a bad CPU.
