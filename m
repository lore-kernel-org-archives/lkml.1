Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbYEXNOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbYEXNOF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 09:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbYEXNNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 09:13:54 -0400
Received: from mail01.fortunecookiestudios.com ([209.208.125.101]:54776 "EHLO
	mail01.fortunecookiestudios.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752399AbYEXNNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 09:13:54 -0400
From: Andras Mantia <amantia@kde.org>
To: linux-kernel@vger.kernel.org
Subject: Re: libata (pata_via) timeouts causing unusable device: the famous DRDY issue?
Date: Sat, 24 May 2008 16:12:29 +0300
User-Agent: KMail/1.9.51 (Linux/2.6.25.4-2-default; KDE/4.0.80; x86_64; svn-810390; 2008-05-20)
References: <200805232201.51701.amantia@kde.org> <48372989.3000700@garzik.org>
In-Reply-To: <48372989.3000700@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805241612.29985.amantia@kde.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 May 2008, Jeff Garzik wrote:
> Have you tried all of: pci=nomsi, acpi=off, or noapic?


So far:
pci=nomsi does not help
pci=nomsi acpi=off noapic works
pci=nomsi noapic also works

I will try noapic only as well and report.

Andras

-- 
 
Quanta Plus developer - http://quanta.kdewebdev.org
K Desktop Environment - http://www.kde.org
