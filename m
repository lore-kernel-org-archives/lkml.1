Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbYEaUQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbYEaUQT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 16:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYEaUQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 16:16:08 -0400
Received: from mail01.fortunecookiestudios.com ([209.208.125.101]:53866 "EHLO
	mail01.fortunecookiestudios.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751812AbYEaUQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 16:16:07 -0400
From: Andras Mantia <amantia@kde.org>
Subject: Re: libata (pata_via) timeouts causing unusable device: the famous DRDY issue?
To: linux-kernel@vger.kernel.org
Date: Sat, 31 May 2008 23:16:04 +0300
References: <200805232201.51701.amantia@kde.org> <48372989.3000700@garzik.org> <200805241612.29985.amantia@kde.org> <483835DD.3060304@garzik.org>
User-Agent: KNode/0.99.01
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Message-Id: <20080531201607.DFFA64E90014@mail01.fortunecookiestudios.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:

>> I will try noapic only as well and report.
> 
> Generally you only want to use one of those...
>

I don't know too much of the kernel's internals... Anyway, I tried and noapic only fixes the problem. It seems the issue is the same that was reported in another thread as well meantime.

Andras

-- 
Quanta Plus developer - http://quanta.kdewebdev.org
K Desktop Environment - http://www.kde.org
