Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbYF1PoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbYF1PoS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 11:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbYF1PoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 11:44:09 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:39841 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbYF1PoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 11:44:08 -0400
Message-ID: <48665C44.9030209@aitel.hist.no>
Date: Sat, 28 Jun 2008 17:44:04 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
Organization: HiST
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Agner Fog <agner@agner.org>
CC: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: ABI change for device drivers using future AVX instruction set
References: <48626514.2040905@agner.org>	<20080625092224.736c2541@infradead.org> <4862ECAB.1040402@zytor.com>	<4864CFA5.9050901@agner.org> <20080627072231.7337ba18@infradead.org>	<4865F0DA.2050906@agner.org> <87myl5pyqo.fsf@basil.nowhere.org> <4866541F.1060709@agner.org>
In-Reply-To: <4866541F.1060709@agner.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Agner Fog wrote:

> You see why I want proper documentation? If this had been documented in 
> some reference that was easy to find, I wouldn't have needed to take 
> your time with all these questions...

This is correct - but then someone would have to use time to write that 
documentation _and keep it up-to-date_. So far, nobody volunteered.
You should feel free to add your newly gained information to the
existing incomplete documentation. :)

This is how open-source works - there is no "boss/management"
that can put someone on the less popular jobs.
No matter how useful this might be.
You want something extra - driver or docs - you make it.

Helge Hafting
